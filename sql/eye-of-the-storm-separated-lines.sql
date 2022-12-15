DECLARE @storm TABLE  (part_line geography, ID INT)

DECLARE @i int = 0

WHILE @i < (SELECT COUNT(*) FROM [geo].[irma_best_track] geo)
BEGIN
    SET @i = @i + 1
    INSERT INTO @storm (part_line, ID)
	SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326).STBuffer(500*AVG(dbo.INTENSITY)),@i
	FROM [dvadb].[geo].[irma_best_track] geo
	JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 
	WHERE dbo.ID > @i AND  dbo.ID <= (@i + 2)
END

SELECT * FROM @storm
