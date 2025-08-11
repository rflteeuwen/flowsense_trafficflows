WITH
    ENVELOPE AS (
        SELECT ST_Envelope(ST_Transform(ST_Buffer(ST_Union(geom), 1000), 4326)) AS bbox
        FROM boundaries.regso_2018_v1
        WHERE kommunnamn = 'Göteborg'
    ),
    CORNERS AS (
        SELECT ST_PointN(ST_ExteriorRing(bbox), 1) AS point FROM ENVELOPE
        UNION ALL
        SELECT ST_PointN(ST_ExteriorRing(bbox), 3) FROM ENVELOPE
    )
SELECT
    MIN(ST_X(point)) AS MinX,
    MIN(ST_Y(point)) AS MinY,
    MAX(ST_X(point)) AS MaxX,
    MAX(ST_Y(point)) AS MaxY
FROM CORNERS;

-- Stockholm
-- x 17.74311562305049,18.217594569705895
-- y 59.21832212787377,59.449258855621075

DROP TABLE IF EXISTS extracts.sthlm_2024 CASCADE;

CREATE TABLE extracts.sthlm_2024 AS
    SELECT
        ST_Transform(geom, 3006) as geom,
        device_uid, timestamp_se,
        ST_X(ST_Transform(geom, 3006)) as x,
        ST_Y(ST_Transform(geom, 3006)) as y
    FROM processed.point_types_2024
    WHERE (
        x BETWEEN 17.74311562305049 AND 18.217594569705895
        AND
        y BETWEEN 59.21832212787377 AND 59.449258855621075);

-- Gothenburg
-- x 11.563185352566668,12.258419171714955
-- y 57.49069409188318,57.87497609543377

DROP TABLE IF EXISTS extracts.gbg_2024 CASCADE;

CREATE TABLE extracts.gbg_2024 AS
    SELECT
        ST_Transform(geom, 3006) as geom,
        device_uid, timestamp_se,
        ST_X(ST_Transform(geom, 3006)) as x,
        ST_Y(ST_Transform(geom, 3006)) as y
    FROM processed.point_types_2024
    WHERE (
        x BETWEEN 11.563185352566668 AND 12.258419171714955
        AND
        y BETWEEN 57.49069409188318 AND 57.87497609543377);