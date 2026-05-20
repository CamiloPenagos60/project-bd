-- liquibase formatted sql

-- changeset estudiante_ing:15
INSERT INTO plataforma (nombre, fabricante) VALUES 
('PC', 'Varios'), ('PlayStation 5', 'Sony'), ('Nintendo Switch', 'Nintendo');

INSERT INTO genero (nombre, descripcion) VALUES 
('RPG', 'Role-Playing Game'), ('Acción', 'Juegos de acción rápida'), ('Aventura', 'Exploración y narrativa');

INSERT INTO videojuego (titulo, desarrollador, fecha_lanzamiento) VALUES 
('The Witcher 3', 'CD Projekt Red', '2015-05-19'),
('Zelda: Breath of the Wild', 'Nintendo', '2017-03-03');

INSERT INTO videojuego_plataforma (id_videojuego, id_plataforma) VALUES (1, 1), (1, 2), (2, 3);
INSERT INTO videojuego_genero (id_videojuego, id_genero) VALUES (1, 1), (2, 1), (2, 3);
-- rollback DELETE FROM videojuego_genero; DELETE FROM videojuego_plataforma; DELETE FROM videojuego; DELETE FROM genero; DELETE FROM plataforma;