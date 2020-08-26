const express = require('express')
const aplicacion = express()
const bodyParser = require('body-parser')
const session = require('express-session')
const flash = require('express-flash')
const fileUpload = require('express-fileupload')
const mysql = require('mysql')


const rutasMiddleware = require('./routes/middleware')
const rutasPublicas = require('./routes/publicas')
const rutasPrivadas = require('./routes/privadas')

var pool = mysql.createPool({
  connectionLimit: 20,
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'blog_viajes'
})	

aplicacion.use(bodyParser.json())
aplicacion.use(bodyParser.urlencoded({ extended: true }))
aplicacion.set("view engine", "ejs")
aplicacion.use(session({ secret: 'token-muy-secreto', resave: true, saveUninitialized: true }));
aplicacion.use(flash())
aplicacion.use(express.static('public'))
aplicacion.use(fileUpload())

aplicacion.use(rutasMiddleware)
aplicacion.use(rutasPublicas)
aplicacion.use(rutasPrivadas)

aplicacion.use(bodyParser.json())
aplicacion.use(bodyParser.urlencoded({ extended: true }))

// GET /api/v1/publicaciones
//JSON con todas las publicaciones.
// GET /api/v1/publicaciones?busqueda=<palabra>
//JSON con todas las publicaciones que tengan la palabra <palabra> en el título, contenido o resumen.
aplicacion.get('/api/v1/publicaciones/', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    let query
    const busqueda = (peticion.query.busqueda) ? peticion.query.busqueda : ""
    if (busqueda == "") {
      query = `SELECT * FROM publicaciones`
    } else {
      query = ` 
              SELECT * FROM 
              publicaciones 
              WHERE titulo LIKE '%${busqueda}%' 
              OR resumen LIKE '%${busqueda}%' 
              OR contenido LIKE '%${busqueda}%'
              `
    }

    connection.query(query, function (error, filas) {
      if (filas.length > 0) {
        respuesta.json({ data: filas })
      } else {
        respuesta.status(404)
        respuesta.send({ errors: ["No se encuentra esa publicacion"] })
      }
    })
    connection.release()
  })
})

//GET /api/v1/publicaciones/<id>
//Publicación con id = <id>. Considera cuando el id no existe.
aplicacion.get('/api/v1/publicaciones/:id', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    const query = `
          SELECT * FROM 
          publicaciones 
          WHERE id=${connection.escape(peticion.params.id)}
          `
    connection.query(query, function (error, filas) {
      if (filas.length > 0) {
        respuesta.json({ data: filas[0] })
      }
      else {
        respuesta.status(404)
        respuesta.send({ errors: ["No se encuentra esa publicación"] })
      }
    })
    connection.release()
  })
})

//GET /api/v1/autores
//JSON con todos los autores.
aplicacion.get('/api/V1/autores', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    const query = `SELECT * FROM autores`
    connection.query(query, function (error, filas) {
      respuesta.json({ data: filas })
    })
    connection.release()
  })
})

// GET /api/v1/autores/<id> 
//JSON con la información del autor con id = <id> y este contiene sus publicaciones. Considera cuando el id no existe.
aplicacion.get('/api/v1/autores/:id', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    const query = `
          SELECT * FROM 
          autores 
          WHERE id=${connection.escape(peticion.params.id)}
          `
    connection.query(query, function (error, filas) {
      if (filas.length > 0) {
        respuesta.json({ data: filas[0] })
      }
      else {
        respuesta.status(404)
        respuesta.send({ errors: ["No se encuentra el autor"] })
      }
    })
    connection.release()
  })
})

// POST /api/v1/autores
//Crea un autor dado un pseudónimo, email, contraseña. Validar peticiones con pseudónimos duplicados o email duplicados. Devuelve un JSON con el objeto creado
aplicacion.post('/api/v1/autores', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    const email = peticion.body.email.toLowerCase().trim()
    const pseudonimo = peticion.body.pseudonimo.trim()
    const contrasena = peticion.body.contrasena
    const consultaEmail = `
          SELECT *
          FROM autores
          WHERE email = ${connection.escape(email)}
          `;
    connection.query(consultaEmail, function (error, filas, campos) {
      if (filas.length > 0) {
        respuesta.status(201)
        respuesta.json({ data: filas[0] })
      }
      else {
        const consultaPseudonimo = `
              SELECT *
              FROM autores
              WHERE pseudonimo = ${connection.escape(pseudonimo)}
              `;
        connection.query(consultaPseudonimo, function (error, filas, campos) {
          if (filas.length > 0) {
            respuesta.status(201)
            respuesta.json({ data: filas[0] })
          }
          else {
            const consulta = `
                  INSERT INTO
                  autores
                  (email, contrasena, pseudonimo)
                  VALUES (
                  ${connection.escape(email)},
                  ${connection.escape(contrasena)},
                  ${connection.escape(pseudonimo)}
                  )
                  `;
            connection.query(consulta, function (error, filas, campos) {
              respuesta.status(201)
              respuesta.json({ data: filas[0] })
            })
          }
        })
      }
    })
    connection.release()
  })
})

// POST /api/v1/publicaciones?email=<email>&contrasena=<contrasena>
//Crea una publicación para el usuario con <email> = email,si este se puede validar correctamente con la contraseña. Se le envía un título, resumen y contenido. Devuelve un JSON con el objeto creado.
aplicacion.post('/api/v1/publicaciones', function (peticion, respuesta) {
  const email = peticion.body.email
  const contrasena = peticion.body.contrasena
  const titulo = peticion.body.titulo
  const resumen = peticion.body.resumen
  const contenido = peticion.body.contenido

  pool.getConnection(function (err, connection) {
    const consultaUsserPass = `
          SELECT *
          FROM autores
          WHERE
          email = ${connection.escape(email)} AND
          contrasena = ${connection.escape(contrasena)}
          `;

    connection.query(consultaUsserPass, (error, filas) => {
      if (filas.length <= 0) {
        respuesta.status(404)
        respuesta.json({ data: filas[0] })
      } else {
        let usuario = filas[0]
        const consulta = `
              INSERT INTO
              publicaciones
              (titulo, resumen, contenido, autor_id)
              VALUES (
              ${connection.escape(titulo)},
              ${connection.escape(resumen)},
              ${connection.escape(contenido)},
              ${connection.escape(usuario.id)}
              )
              `;
      connection.query(consulta, (error, filas) => {
        const nuevoId = filas.insertId
        const queryConsulta = `
              SELECT * FROM
              publicaciones 
              WHERE id=${connection.escape(nuevoId)}
              `
            connection.query(queryConsulta, function (error, filas) {
            respuesta.status(201)
            respuesta.json({ data: filas[0] })
          })
        })
      }
    })
    connection.release()
  })
})

//DELETE /api/v1/publicaciones/<id>?email=<email>&contrasena=<contrasena></contrasena>
//Elimina la publicación si las credenciales son correctas y la publicación le pertenece al usuario.
aplicacion.delete('/api/v1/publicaciones/:id', function (peticion, respuesta) {

  pool.getConnection(function (err, connection) {

    const errores = []
    const query = `
          SELECT * FROM 
          autores 
          WHERE email=${connection.escape(peticion.query.email)} 
          `
    connection.query(query, function (error, filas1, campos) {

      const query = `
            SELECT * FROM 
            publicaciones 
            WHERE id=${connection.escape(peticion.params.id)}   
            `
      connection.query(query, function (error, filas4, campos) {

        if (filas1.length > 0) {
          if (filas1[0].contrasena != peticion.query.contrasena) {
            errores.push("Datos de usuario incorrectos")
          }
          if (filas4.length > 0) {
            if (filas1[0].id != filas4[0].autor_id) {
              errores.push("Esta publicacion no pertenece al usuario")
            }
          }
          else {
            errores.push("El id de la publicacion no existe")
          }
        }
        else {
          errores.push("El autor no esta registrado")
        }

        if (errores.length > 0) {
          respuesta.status(404)
          respuesta.json({ errores: errores })
        }
        else {
          const queryDelete = `
                DELETE FROM
                publicaciones 
                WHERE id=${connection.escape(peticion.params.id)}
                `
          connection.query(queryDelete, function (error, filas, campos) {
            respuesta.status(204)
            respuesta.json()
          })
        }
      })
    })
    connection.release()
  })
})

aplicacion.listen(8080, function () {
  console.log("Servidor iniciado")
})