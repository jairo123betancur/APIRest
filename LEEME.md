# Inicio de Sesión

Para crear el inicio de sesión debes:

- Crear el formulario
- Crear el proceso del formulario
- Colocar un encabezado de páginas privadas
- Validar la sesión

## Crear el formulario

```HTML
<form action="/procesar_inicio" method="POST">
  <fieldset>
    <legend>Datos para entrar</legend>
    <p>
      <label for="email">Email</label>
      <br>
      <input type="email" id="email" name="email" required="true" />
    </p>
    <p>
      <label for="contrasena">Contrasena</label>
      <br>
      <input type="password" id="contrasena" name="contrasena" required="true" />
    </p>
    <p>
      <input class="primary" type="submit" value="Continuar" />
    </p>
  </fieldset>
</form>
```

## Crear el proceso del formulario


```Javascript
aplicacion.post('/procesar_inicio', function (peticion, respuesta) {
  pool.getConnection(function (err, connection) {
    const consulta = `
      SELECT *
      FROM autores
      WHERE
      email = ${connection.escape(peticion.body.email)} AND
      contrasena = ${connection.escape(peticion.body.contrasena)}
    `
    connection.query(consulta, function (error, filas, campos) {
      if (filas.length > 0) {
        peticion.session.usuario = filas[0]
        respuesta.redirect('/admin/index')
      }
      else {
        peticion.flash('mensaje', 'Datos inválidos')
        respuesta.redirect('/inicio')
      }

    })
    connection.release()
  })
})
```

## Colocar un encabezado de páginas privadas

En `views/partials/encabezado_privado.ejs`

```HTML
<header class="sticky">
  <div class="enlaces-registro">
    <span class="icon-user"></span>
    <%=usuario.pseudonimo%> |
    <a href="/procesar_cerrar_sesion">Cerrar Sesion</a>
  </div>
  <a href="#" class="logo">Blog de Viajes</a>
  <a href="/admin/index" class="button"><span class="icon-credit"></span>Admin</a>
</header>
```

## Validar la sesión

```Javascript
aplicacion.use('/admin/', (peticion, respuesta, siguiente) => {
  if (!peticion.session.usuario) {
    peticion.flash('mensaje', 'Debe iniciar sesión')
    respuesta.redirect("/inicio")
  }
  else {
    siguiente()
  }
})
```
