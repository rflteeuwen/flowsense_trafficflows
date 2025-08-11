-- Jorge Gil, 2025
-- process extract of raw or pre-processed data to create data point types for classification

-- query preparation adding indices to the pre-processed data
CREATE INDEX extract_to_process_aid_idx ON extracts.sthlm_2024 (device_uid) INCLUDE (timestamp_se);
-- query preparation adding indices to the raw data
--CREATE INDEX extract_to_process_aid_idx ON extracts.sthlm (device_aid) INCLUDE (timestamp);

DROP TABLE IF EXISTS extracts.sthlm_point_types_2024 CASCADE;
CREATE TABLE extracts.sthlm_point_types_2024 -- rename to something else if needed
(
    sid          BIGSERIAL PRIMARY KEY,
    geom         GEOMETRY('Point', 3006),
    device_uid   UUID,                     -- unique device/user id
    timestamp_se TIMESTAMP WITH TIME ZONE, -- timestamp with Swedish time zone
    x            FLOAT,                  -- SWED projected coordinates
    y            FLOAT,                  -- SWED projected coordinates
    accuracy     NUMERIC(6, 1),            -- (horizontal) metres
    method       VARCHAR(5),               -- label for location method (gps, wifi, fused,?)
    type         VARCHAR,                  -- data point class (custom TBD)
    in_duration  FLOAT,                  -- seconds
    in_distance  FLOAT,                  -- metres
    in_bearing   FLOAT,                   -- degrees
    in_speed     DOUBLE PRECISION,          -- km/h
    out_duration FLOAT,                  -- seconds
    out_distance FLOAT,                  -- metres
    out_bearing   FLOAT,                   -- degrees
    out_speed    DOUBLE PRECISION,          -- km/h
    series       INTEGER,                  -- sequence for each unique device
    is_last      BOOLEAN,                  -- last point in the series
    is_grid      BOOLEAN,                  -- likely to be in a grid pattern
    is_stationary BOOLEAN                   -- only location of device
);

WITH data_with_geom AS(
        SELECT geom AS geom, device_uid AS device_uid, timestamp_se AS timestamp -- for pre-processed data
        -- SELECT ST_Transform(ST_SetSRID(ST_Point(longitude, latitude), 4326),3006) AS geom, uuid(device_aid) AS device_aid, to_timestamp(timestamp) AS timestamp -- for raw data
        FROM  extracts.sthlm_2024 -- rename as required
    ),
     points_sequence AS (
        SELECT geom, device_uid AS device_uid, timestamp at time zone 'Europe/Stockholm' AS timestamp_se, ST_X(geom) AS x, ST_Y(geom) AS y,
            EXTRACT(epoch FROM age(timestamp,lag(timestamp) OVER device_window)) AS in_duration,
            ST_Distance(geom,lag(geom) OVER device_window) AS in_distance,
            degrees(ST_Azimuth(geom,lag(geom) OVER device_window)) AS in_bearing,
            EXTRACT(epoch FROM age(lead(timestamp) OVER device_window, timestamp)) AS out_duration,
            ST_Distance(geom,lead(geom) OVER device_window) AS out_distance,
            degrees(ST_Azimuth(geom,lead(geom) OVER device_window)) AS out_bearing,
            row_number() OVER device_window AS series
        FROM data_with_geom
        WINDOW device_window AS (PARTITION BY device_uid ORDER BY timestamp)
),
     points_with_speed AS (
         SELECT *,
            (in_distance/1000.0)/NULLIF((in_duration/3600.0),0) AS in_speed,
            (out_distance/1000.0)/NULLIF((out_duration/3600.0),0) AS out_speed
         FROM points_sequence
)
INSERT INTO extracts.sthlm_point_types_2024 (geom, device_uid, timestamp_se, x, y,
            in_duration, in_distance, in_bearing, out_duration, out_distance, out_bearing, series, in_speed, out_speed, type)
    SELECT geom, device_uid, timestamp_se, x, y,in_duration, in_distance, in_bearing,
           out_duration, out_distance, out_bearing, series, in_speed, out_speed,
        CASE
            WHEN (in_speed > 250 AND out_speed > 250) THEN 'error'
            WHEN (in_speed IS NULL AND out_speed IS NULL) THEN 'singular'
            WHEN (in_speed > 3) AND (out_speed > 3) THEN 'movement'
            WHEN (in_speed > 3) AND ((out_speed <= 3 AND out_distance <= 100) OR out_speed IS NULL) THEN 'stop'
            WHEN ((in_speed <= 3 AND in_distance <= 100) OR in_speed IS NULL) AND (out_speed > 3) THEN 'start'
            WHEN ((in_speed <= 3 AND in_distance <= 100) OR in_speed IS NULL) AND ((out_speed <= 3 AND out_distance <= 100) OR out_speed IS NULL) THEN 'stay'
            WHEN ((in_speed <= 3 AND in_distance > 100) AND (out_speed <= 3 AND out_distance > 100)) THEN 'isolated'
            WHEN (in_speed <= 3 AND in_distance > 100) AND (out_speed > 3) THEN 'speed up'
            WHEN (in_speed > 3) AND (out_speed <= 3 AND out_distance > 100) THEN 'slow down'
            WHEN (in_speed <= 3 AND in_distance > 100) AND ((out_speed <= 3 AND out_distance <= 100) OR out_speed IS NULL) THEN 'slow stop'
            WHEN ((in_speed <= 3 AND in_distance <= 100) OR in_speed IS NULL) AND (out_speed <= 3 AND out_distance > 100) THEN 'slow start'
        END AS type
    FROM points_with_speed
;

-- This update is quite fast
UPDATE extracts.sthlm_point_types_2024 SET
    is_last = TRUE
    WHERE out_speed IS NULL
;

UPDATE extracts.sthlm_point_types_2024 SET
    is_stationary = TRUE
    WHERE device_uid IN (SELECT device_uid FROM (
            SELECT device_uid, count(DISTINCT geom) count
            FROM extracts.sthlm_point_types_2024
            GROUP BY device_uid) AS a
            WHERE a.count = 1
        )
;

/*
-- This update is slower than the main classification.
UPDATE processed.point_types_sample SET
    is_grid = TRUE
    WHERE geom IN (SELECT geom
        FROM (SELECT geom, count(*) points_count, count(DISTINCT device_uid) device_count
            FROM processed.point_types_sample
            GROUP BY geom) AS a
        WHERE a.points_count > 200 AND a.device_count > 5
        )
;
*/

-- add spatial index to geometries
CREATE INDEX sthlm_point_types_2024_geom_sidx ON extracts.sthlm_point_types_2024 USING GIST (geom);

-- Drop processing index
DROP INDEX extracts.extract_to_process_aid_idx CASCADE;
