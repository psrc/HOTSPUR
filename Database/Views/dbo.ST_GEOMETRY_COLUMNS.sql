SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[ST_GEOMETRY_COLUMNS] (table_schema, table_name,       column_name, type_schema, type_name,  srs_id) AS        SELECT f_table_schema, f_table_name, f_geometry_column,'dbo',       CASE geometry_type        WHEN 0 THEN 'ST_GEOMETRY'        WHEN 1 THEN 'ST_POINT'        WHEN 2 THEN 'ST_CURVE'        WHEN 3 THEN 'ST_LINESTRING'        WHEN 4 THEN 'ST_SURFACE'        WHEN 5 THEN 'ST_POLYGON'        WHEN 6 THEN 'ST_COLLECTION'        WHEN 7 THEN 'ST_MULTIPOINT'        WHEN 8 THEN 'ST_MULTICURVE'        WHEN 9 THEN 'ST_MULTISTRING'        WHEN 10 THEN 'ST_MULTISURFACE'        WHEN 11 THEN 'ST_MULTIPOLYGON'        ELSE 'ST_GEOMETRY'        END,        srid FROM dbo.SDE_geometry_columns g
GO
GRANT SELECT ON  [dbo].[ST_GEOMETRY_COLUMNS] TO [public]
GO
