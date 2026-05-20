-- liquibase formatted sql

-- changeset estudiante_ing:9
-- Llaves Foráneas
ALTER TABLE videojuego_plataforma ADD CONSTRAINT fk_vp_videojuego FOREIGN KEY (id_videojuego) REFERENCES videojuego(id_videojuego) ON DELETE CASCADE;
ALTER TABLE videojuego_plataforma ADD CONSTRAINT fk_vp_plataforma FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma) ON DELETE CASCADE;

ALTER TABLE videojuego_genero ADD CONSTRAINT fk_vg_videojuego FOREIGN KEY (id_videojuego) REFERENCES videojuego(id_videojuego) ON DELETE CASCADE;
ALTER TABLE videojuego_genero ADD CONSTRAINT fk_vg_genero FOREIGN KEY (id_genero) REFERENCES genero(id_genero) ON DELETE CASCADE;

ALTER TABLE coleccion ADD CONSTRAINT fk_col_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE;
ALTER TABLE coleccion ADD CONSTRAINT fk_col_videojuego FOREIGN KEY (id_videojuego) REFERENCES videojuego(id_videojuego) ON DELETE CASCADE;
ALTER TABLE coleccion ADD CONSTRAINT fk_col_plataforma FOREIGN KEY (id_plataforma) REFERENCES plataforma(id_plataforma) ON DELETE CASCADE;

ALTER TABLE resena ADD CONSTRAINT fk_res_coleccion FOREIGN KEY (id_coleccion) REFERENCES coleccion(id_coleccion) ON DELETE CASCADE;
-- rollback ALTER TABLE resena DROP CONSTRAINT fk_res_coleccion; ALTER TABLE coleccion DROP CONSTRAINT fk_col_plataforma; ALTER TABLE coleccion DROP CONSTRAINT fk_col_videojuego; ALTER TABLE coleccion DROP CONSTRAINT fk_col_usuario; ALTER TABLE videojuego_genero DROP CONSTRAINT fk_vg_genero; ALTER TABLE videojuego_genero DROP CONSTRAINT fk_vg_videojuego; ALTER TABLE videojuego_plataforma DROP CONSTRAINT fk_vp_plataforma; ALTER TABLE videojuego_plataforma DROP CONSTRAINT fk_vp_videojuego;

-- changeset estudiante_ing:10
-- Restricciones UNIQUE y CHECK (Reglas de Negocio)
ALTER TABLE usuario ADD CONSTRAINT uk_usuario_correo UNIQUE (correo);
ALTER TABLE usuario ADD CONSTRAINT uk_usuario_alias UNIQUE (alias);
ALTER TABLE coleccion ADD CONSTRAINT uk_coleccion_juego_plataforma UNIQUE (id_usuario, id_videojuego, id_plataforma); -- RN05
ALTER TABLE resena ADD CONSTRAINT chk_calificacion CHECK (calificacion >= 1 AND calificacion <= 5); -- RN02
ALTER TABLE coleccion ADD CONSTRAINT chk_estado CHECK (estado_juego IN ('Por jugar', 'Jugando', 'Terminado', 'Abandonado'));
-- rollback ALTER TABLE coleccion DROP CONSTRAINT chk_estado; ALTER TABLE resena DROP CONSTRAINT chk_calificacion; ALTER TABLE coleccion DROP CONSTRAINT uk_coleccion_juego_plataforma; ALTER TABLE usuario DROP CONSTRAINT uk_usuario_alias; ALTER TABLE usuario DROP CONSTRAINT uk_usuario_correo;

-- changeset estudiante_ing:11
-- Índices justificados (Para acelerar las consultas por estado y búsquedas de usuario)
CREATE INDEX idx_coleccion_usuario ON coleccion(id_usuario);
CREATE INDEX idx_coleccion_estado ON coleccion(estado_juego);
CREATE INDEX idx_resena_coleccion ON resena(id_coleccion);
-- rollback DROP INDEX idx_resena_coleccion; DROP INDEX idx_coleccion_estado; DROP INDEX idx_coleccion_usuario;