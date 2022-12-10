SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326).STBuffer(50000) as avg_storm_line
FROM [dvadb].[geo].[irma_best_track] geo
