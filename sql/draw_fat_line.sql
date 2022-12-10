SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326).STBuffer(250*AVG(dbo.INTENSITY)) as avg_storm_line
FROM [dvadb].[geo].[irma_best_track] geo
JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 
UNION ALL
SELECT geography::UnionAggregate(county_shape)
FROM geo.florida_counties