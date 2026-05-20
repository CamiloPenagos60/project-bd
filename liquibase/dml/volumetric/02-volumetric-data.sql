-- liquibase formatted sql

-- changeset estudiante_ing:16
-- Insertar 1,000 usuarios masivos
INSERT INTO usuario (alias, correo)
SELECT 
    'player_' || seq, 
    'player_' || seq || '@ejemplo.com'
FROM generate_series(1, 1000) AS seq;

-- Asignar el juego 1 (The Witcher 3 en PC) a los primeros 500 usuarios
INSERT INTO coleccion (id_usuario, id_videojuego, id_plataforma, estado_juego)
SELECT id_usuario, 1, 1, 'Jugando'
FROM usuario WHERE id_usuario <= 500;

-- Generar reseñas para los primeros 250 usuarios
INSERT INTO resena (id_coleccion, calificacion, comentario)
SELECT id_coleccion, (random() * 4 + 1)::INT, 'Buen juego.'
FROM coleccion WHERE id_usuario <= 250;
-- rollback TRUNCATE TABLE resena CASCADE; TRUNCATE TABLE coleccion CASCADE; TRUNCATE TABLE usuario CASCADE;