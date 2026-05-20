-- liquibase formatted sql

-- changeset estudiante_ing:12 splitStatements:false
-- Vista de catálogo (Evita joins repetitivos para ver el catálogo)
CREATE VIEW vista_catalogo_completo AS
SELECT v.id_videojuego, v.titulo, v.desarrollador, 
       STRING_AGG(DISTINCT p.nombre, ', ') AS plataformas,
       STRING_AGG(DISTINCT g.nombre, ', ') AS generos
FROM videojuego v
JOIN videojuego_plataforma vp ON v.id_videojuego = vp.id_videojuego
JOIN plataforma p ON vp.id_plataforma = p.id_plataforma
JOIN videojuego_genero vg ON v.id_videojuego = vg.id_videojuego
JOIN genero g ON vg.id_genero = g.id_genero
GROUP BY v.id_videojuego, v.titulo, v.desarrollador;
-- rollback DROP VIEW vista_catalogo_completo;

-- changeset estudiante_ing:13 splitStatements:false
-- Función y Trigger: RN04 - Validar fecha de lanzamiento no futura
CREATE OR REPLACE FUNCTION fn_validar_fecha_lanzamiento()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha_lanzamiento > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha de lanzamiento no puede ser en el futuro.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_fecha
BEFORE INSERT OR UPDATE ON videojuego
FOR EACH ROW EXECUTE PROCEDURE fn_validar_fecha_lanzamiento();
-- rollback DROP TRIGGER trg_validar_fecha ON videojuego; DROP FUNCTION fn_validar_fecha_lanzamiento();

-- changeset estudiante_ing:14 splitStatements:false
-- Procedure: Agregar juego a colección encapsulando la lógica
CREATE OR REPLACE PROCEDURE sp_agregar_juego_coleccion(
    p_id_usuario INT,
    p_id_videojuego INT,
    p_id_plataforma INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO coleccion (id_usuario, id_videojuego, id_plataforma, estado_juego)
    VALUES (p_id_usuario, p_id_videojuego, p_id_plataforma, 'Por jugar');
    COMMIT;
END;
$$;
-- rollback DROP PROCEDURE sp_agregar_juego_coleccion(INT, INT, INT);