-- liquibase formatted sql

-- changeset estudiante_ing:17
-- Update Controlado: Los usuarios del 1 al 100 terminaron el juego
UPDATE coleccion 
SET estado_juego = 'Terminado' 
WHERE id_usuario <= 100 AND id_videojuego = 1;

-- Delete Controlado: Soft-delete de reseñas (Regla de negocio: no borrar de la BD, marcar como eliminada)
UPDATE resena 
SET eliminada = TRUE 
WHERE calificacion = 1; 
-- rollback UPDATE resena SET eliminada = FALSE WHERE eliminada = TRUE; UPDATE coleccion SET estado_juego = 'Jugando' WHERE id_usuario <= 100 AND id_videojuego = 1;