# proyecto Biblioteca de video juegos 

# 1. Funcionamiento de las Tablas y Modelo Relacional
El modelo de datos se estructuró aplicando las formas normales tradicionales para eliminar redundancias y salvaguardar la integridad referencial. A continuación, se detalla la semántica y el comportamiento de cada entidad implementada:

## A. Entidades del Catálogo Maestro
- usuario: Almacena las cuentas registradas en el ecosistema. Cuenta con restricciones de unicidad (UNIQUE) en campos críticos como el correo electrónico y el alias del jugador, impidiendo la duplicación de identidades. Su identificador es autoincremental (SERIAL). 

- plataforma: Define los entornos de hardware/ecosistemas (PC, PlayStation 5, Nintendo Switch) donde se pueden ejecutar los videojuegos. Actúa como tabla de tipificación estática.

- genero: Alberga las clasificaciones temáticas y mecánicas de los títulos (RPG, Acción, Aventura).

- videojuego: Catálogo central de títulos desarrollados, capturando metadatos clave como el título, la compañía desarrolladora y la fecha oficial de lanzamiento.

## B. Entidades Operacionales e Intermedias
- coleccion: Es la entidad pivote (intermedia) del sistema. Modela una relación de muchos a muchos de forma enriquecida, conectando un usuario, un videojuego y una plataforma específica.

- Regla de Negocio Crítica: Aplica una restricción de unicidad compuesta (uk_coleccion_juego_plataforma) que impide que un mismo usuario agregue el mismo videojuego dos veces para la misma plataforma, permitiendo sin embargo tener el mismo juego en plataformas distintas.

- Restricción CHECK: El campo estado_juego se encuentra restringido a valores predefinidos y controlados de progreso: 'Por jugar', 'Jugando', 'Terminado', 'Abandonado'.

- resena: Almacena las evaluaciones cualitativas y cuantitativas del rendimiento de los videojuegos por parte de los usuarios.

- Regla de Negocio Crítica: Está ligada directamente a un registro de coleccion mediante una relación 1:1 estricta con restricción UNIQUE en id_coleccion, asegurando que un usuario solo pueda calificar un juego que efectivamente posee en su biblioteca personal.

- Restricción CHECK: El campo calificacion cuenta con una regla de validación de rango numérico estricto entre 1 y 5.

- Manejo de Ciclo de Vida (Soft Delete): Dispone de un campo booleano eliminada. Las políticas del sistema estipulan el no borrado físico de valoraciones para resguardar las métricas de auditoría histórica, usando este flag para exclusiones lógicas en la capa de visualización.

## C. Comportamiento en Cascada (ON DELETE CASCADE)
Todas las relaciones de llaves foráneas han sido parametrizadas con políticas de eliminación en cascada. Si un usuario se da de baja del sistema o un videojuego es removido del catálogo maestro por el administrador, todos los registros dependientes dentro de las tablas coleccion y resena se depuran automáticamente, previniendo la existencia de registros huérfanos o inconsistencias referenciales.

# 2. Flujo de Control de Cambios: Separación DDL/DML
La orquestación de despliegues controlada por liquibase/changelog/db.changelog-master.yaml ejecuta los scripts en tres fases secuenciales obligatorias:

- Fase DDL Structural (liquibase/ddl/): Construye la base física sin datos. Primero se crean las estructuras limpias de las tablas y, de forma posterior, se inyectan las llaves foráneas (ALTER TABLE), restricciones avanzadas e índices optimizados (como idx_coleccion_usuario e idx_coleccion_estado) para maximizar la velocidad de búsqueda sobre las consultas más concurrentes del negocio.

- Fase DML Canonical (liquibase/dml/canonical/): Puebla catálogos maestros indispensables para el levantamiento básico de la aplicación (los géneros base, las consolas y los primeros videojuegos del mercado).

- Fase DML Volumetric (liquibase/dml/volumetric/): Simula el comportamiento del sistema bajo estrés real. Empleando la potencia de generate_series de PostgreSQL, inyecta dinámicamente 1,000 registros de usuarios, distribuye cientos de asignaciones de bibliotecas y produce reseñas aleatorias, cerrando con operaciones transaccionales de actualización controlada (UPDATE).

# 3. Guía de Operación Paso a Paso
Siga estrictamente este protocolo desde su terminal de comandos para inicializar, operar y auditar el sistema:

- Paso 1: Inicialización de la Infraestructura
Asegúrese de tener la aplicación Docker Desktop abierta de fondo. Ejecute el siguiente comando en la raíz de su proyecto para descargar, construir e iniciar el motor relacional de manera aislada:

> docker-compose up -d 

 Nota: Puede validar que el puerto local 5433 está escuchando conexiones mapeándolo desde pgAdmin u otra interfaz gráfica.

- Paso 2: Ejecución del Pipeline de Migraciones (Update)
Para aplicar todo el diseño estructural, las restricciones y las cargas masivas de datos canónicos y volumétricos, ejecute el script automatizado:

> .\\scripts\\update.bat

Al finalizar, Liquibase informará en consola un mensaje exitoso: Liquibase: Update has been successful. Rows affected: 1906.

- Paso 3: Ejecución de Reversión Funcional (Rollback)
Si requiere dar marcha atrás y revertir el último bloque de cambios aplicado (por ejemplo, deshacer las actualizaciones de simulación transaccional), ejecute:

> .\\scripts\\rollback.bat

- Paso 4: Apagado Seguro del Entorno
Cuando culmine sus actividades de desarrollo o investigación, apague la infraestructura liberando los recursos de memoria RAM de su sistema operativo anfitrión:

> docker-compose down

# 4. Consulta Avanzada de Validación Analítica
Para validar la correcta integridad de los datos masivos cargados y el óptimo funcionamiento de las restricciones y relaciones complejas del dominio, se diseñó la siguiente consulta SQL analítica que genera un JOIN masivo acoplando 8 tablas simultáneamente para responder a un requerimiento de negocio real:

-- Pregunta de Negocio: Obtener un reporte detallado con el Alias del Jugador, el Título del Videojuego,
-- el Nombre de la Plataforma, el Nombre del Género, el Estado de Progreso actual de la partida y la Calificación
-- numérica otorgada. Filtrando exclusivamente por juegos comprados para 'PC', que correspondan al género 'RPG'
-- y cuyas reseñas se encuentren actualmente activas (no eliminadas lógicamente).

SELECT 
    u.alias AS "Jugador", 
    v.titulo AS "Videojuego", 
    p.nombre AS "Plataforma", 
    g.nombre AS "Género", 
    c.estado_juego AS "Progreso", 
    r.calificacion AS "Nota"
FROM usuario u                                           -- Tabla 1: Origen del Usuario
JOIN coleccion c ON u.id_usuario = c.id_usuario          -- Tabla 2: Relación de Bibliotecas
JOIN videojuego v ON c.id_videojuego = v.id_videojuego   -- Tabla 3: Información General del Juego
JOIN videojuego_plataforma vp ON v.id_videojuego = vp.id_videojuego 
     AND c.id_plataforma = vp.id_plataforma              -- Tabla 4: Intermedia Catálogo-Plataformas
JOIN plataforma p ON vp.id_plataforma = p.id_plataforma  -- Tabla 5: Detalle de la Plataforma física
JOIN videojuego_genero vg ON v.id_videojuego = vg.id_videojuego -- Tabla 6: Intermedia Catálogo-Géneros
JOIN genero g ON vg.id_genero = g.id_genero              -- Tabla 7: Detalle del Género asociado
JOIN resena r ON c.id_coleccion = r.id_coleccion         -- Tabla 8: Evaluación 1:1 de la Experiencia
WHERE 
    p.nombre = 'PC' 
    AND g.nombre = 'RPG'
    AND r.eliminada = FALSE
ORDER BY 
    r.calificacion DESC, 
    u.alias ASC
LIMIT 15;