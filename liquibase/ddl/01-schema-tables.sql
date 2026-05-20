-- liquibase formatted sql

-- changeset estudiante_ing:1
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    alias VARCHAR(50) NOT NULL,
    correo VARCHAR(100) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- rollback DROP TABLE usuario;

-- changeset estudiante_ing:2
CREATE TABLE plataforma (
    id_plataforma SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fabricante VARCHAR(50) NOT NULL
);
-- rollback DROP TABLE plataforma;

-- changeset estudiante_ing:3
CREATE TABLE genero (
    id_genero SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion TEXT
);
-- rollback DROP TABLE genero;

-- changeset estudiante_ing:4
CREATE TABLE videojuego (
    id_videojuego SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    desarrollador VARCHAR(100) NOT NULL,
    fecha_lanzamiento DATE NOT NULL
);
-- rollback DROP TABLE videojuego;

-- changeset estudiante_ing:5
CREATE TABLE videojuego_plataforma (
    id_videojuego INT NOT NULL,
    id_plataforma INT NOT NULL,
    PRIMARY KEY (id_videojuego, id_plataforma)
);
-- rollback DROP TABLE videojuego_plataforma;

-- changeset estudiante_ing:6
CREATE TABLE videojuego_genero (
    id_videojuego INT NOT NULL,
    id_genero INT NOT NULL,
    PRIMARY KEY (id_videojuego, id_genero)
);
-- rollback DROP TABLE videojuego_genero;

-- changeset estudiante_ing:7
CREATE TABLE coleccion (
    id_coleccion SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_videojuego INT NOT NULL,
    id_plataforma INT NOT NULL,
    estado_juego VARCHAR(20) NOT NULL,
    fecha_adquisicion DATE DEFAULT CURRENT_DATE
);
-- rollback DROP TABLE coleccion;

-- changeset estudiante_ing:8
CREATE TABLE resena (
    id_resena SERIAL PRIMARY KEY,
    id_coleccion INT NOT NULL UNIQUE,
    calificacion INT NOT NULL,
    comentario TEXT,
    fecha_resena TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    eliminada BOOLEAN DEFAULT FALSE
);
-- rollback DROP TABLE resena;