-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 26-08-2020 a las 19:38:21
-- Versión del servidor: 10.4.13-MariaDB
-- Versión de PHP: 7.2.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `blog_viajes`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `archive`
--

CREATE TABLE `archive` (
  `id` int(11) NOT NULL,
  `createdAt` bigint(20) DEFAULT NULL,
  `fromModel` varchar(255) DEFAULT NULL,
  `originalRecord` longtext DEFAULT NULL,
  `originalRecordId` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `autores`
--

CREATE TABLE `autores` (
  `id` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `pseudonimo` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `autores`
--

INSERT INTO `autores` (`id`, `email`, `contrasena`, `pseudonimo`, `avatar`) VALUES
(1, 'luis@email.com', '123123', 'luis2000', NULL),
(2, 'ana@email.com', '123123', 'a55555', NULL),
(14, 'carlos@email.com', '123123', 'carlos1', NULL),
(19, 'cuenta.de.correo.ejemplo.1234@email.com', '123123', 'juan0', NULL),
(20, 'pedro@email.com', '1312312', 'pedro111', NULL),
(24, 'jabetancurv93@gmail.com', '24234', 'jabetancurv93', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `person`
--

CREATE TABLE `person` (
  `createdAt` bigint(20) DEFAULT NULL,
  `updatedAt` bigint(20) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `createdAt` bigint(20) DEFAULT NULL,
  `updatedAt` bigint(20) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `nombre` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `publicaciones`
--

CREATE TABLE `publicaciones` (
  `id` int(11) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `resumen` varchar(255) NOT NULL,
  `contenido` varchar(255) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `votos` int(11) DEFAULT 0,
  `fecha_hora` timestamp NULL DEFAULT NULL,
  `autor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `publicaciones`
--

INSERT INTO `publicaciones` (`id`, `titulo`, `resumen`, `contenido`, `foto`, `votos`, `fecha_hora`, `autor_id`) VALUES
(1, 'Roma', 'Buen viaje a Roma', '<p>Contenido <strong>sdsdsd</strong></p>', NULL, 0, '2018-09-10 01:08:27', 1),
(2, 'Grecia', 'Buen viaje a Grecia', '<p>Contenido edds <strong>assd</strong> ad</p>', NULL, 0, '2018-09-11 01:08:27', 1),
(3, 'Paris', 'Buen viaje a Paris', 'Contenido', NULL, 0, '2018-09-12 01:08:27', 1),
(4, 'Costa Rica', 'Buen viaje a Costa Rica', 'Contenido', NULL, 0, '2018-09-13 01:08:27', 2),
(5, 'Mar de Plata', 'Buen viaje a Mar de Plata', 'Contenido', NULL, 0, '2018-09-14 01:08:27', 2),
(6, 'Guadalajara', 'Buen viaje a Guadalajara', '<p>El viaje a <strong>Guadalajara</strong> comenzó en <i>Octubre</i>....</p>', NULL, 0, '2018-09-15 01:08:27', 2),
(7, 'China', 'Buen viaje a China', 'Contenido', NULL, 2, '2018-09-16 01:08:27', 2),
(15, 'New York', 'Viaje a nueva york', '<p>Me gusto este <strong>viaje</strong></p>', NULL, 4, '2018-09-22 00:00:00', 14),
(16, 'Viaje a San Andres', 'buen viaje', '<p>adad adasdas dasdasdasd</p>', NULL, 2, '2020-08-25 05:00:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `view`
--

CREATE TABLE `view` (
  `createdAt` bigint(20) DEFAULT NULL,
  `updatedAt` bigint(20) DEFAULT NULL,
  `id` int(11) NOT NULL,
  `hol` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `archive`
--
ALTER TABLE `archive`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indices de la tabla `autores`
--
ALTER TABLE `autores`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `person`
--
ALTER TABLE `person`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indices de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_publicaciones_autores_idx` (`autor_id`);

--
-- Indices de la tabla `view`
--
ALTER TABLE `view`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `archive`
--
ALTER TABLE `archive`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `autores`
--
ALTER TABLE `autores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT de la tabla `person`
--
ALTER TABLE `person`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `view`
--
ALTER TABLE `view`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `publicaciones`
--
ALTER TABLE `publicaciones`
  ADD CONSTRAINT `fk_publicaciones_autores` FOREIGN KEY (`autor_id`) REFERENCES `autores` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
