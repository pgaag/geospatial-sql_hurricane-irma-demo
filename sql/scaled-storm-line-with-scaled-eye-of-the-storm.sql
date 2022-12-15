DECLARE @storm TABLE  (part_line geography, ID INT)

DECLARE @i int = 0

WHILE @i < (SELECT COUNT(*) FROM [geo].[irma_best_track] geo)
BEGIN
    SET @i = @i + 1
    INSERT INTO @storm (part_line, ID)
	SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326).STBuffer(1250*AVG(dbo.INTENSITY)),@i
	FROM [dvadb].[geo].[irma_best_track] geo
	JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 
	WHERE dbo.ID > @i AND  dbo.ID <= (@i + 2)
END


SELECT geography::UnionAggregate(part_line) as scaled_lines FROM @storm 
UNION ALL
SELECT geography::UnionAggregate(county_shape)
FROM geo.florida_counties
UNION ALL
SELECT huricane_current_pos.STBuffer(350*dbo.INTENSITY) FROM geo.irma_best_track geo
JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 


