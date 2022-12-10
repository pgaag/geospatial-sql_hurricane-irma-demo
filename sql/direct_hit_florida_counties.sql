
DECLARE @storm_line TABLE (storm_line geography)

INSERT INTO @storm_line
SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326) as storm_line
FROM [dvadb].[geo].[irma_best_track] geo
JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 


SELECT county_shape, name FROM @storm_line sl
CROSS APPLY 
   ( 
   SELECT counties.county_shape, counties.name
   FROM geo.florida_counties_with_names counties 
   WHERE sl.storm_line.STIntersects(counties.county_shape) = 1 
   ) A 
UNION ALL
SELECT storm_line, 'storm' FROM @storm_line
