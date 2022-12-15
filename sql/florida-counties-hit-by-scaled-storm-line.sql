DECLARE @storm TABLE  (part_line geography, ID INT)
DECLARE @storm_single_line TABLE  (storm geography)

DECLARE @i int = 0

WHILE @i < (SELECT COUNT(*) FROM [geo].[irma_best_track] geo)
BEGIN
    SET @i = @i + 1
    INSERT INTO @storm (part_line, ID)
	SELECT geography::STGeomFromText('LINESTRING(' + STRING_AGG(CONCAT_WS(' ', geo.huricane_current_pos.Long, geo.huricane_current_pos.Lat),',') + ')',4326).STBuffer(1000*AVG(dbo.INTENSITY)),@i
	FROM [dvadb].[geo].[irma_best_track] geo
	JOIN dbo.irma_best_track dbo ON dbo.ID = geo.metadata_id 
	WHERE dbo.ID > @i AND  dbo.ID <= (@i + 2)
END

INSERT INTO @storm_single_line
SELECT geography::UnionAggregate(part_line) as scaled_lines FROM @storm 

SELECT county_shape, name FROM @storm_single_line sl
CROSS APPLY 
   ( 
   SELECT counties.county_shape, counties.name
   FROM geo.florida_counties_with_names counties 
   WHERE sl.storm.STIntersects(counties.county_shape) = 1 
   ) A 
UNION ALL
SELECT storm, 'storm' FROM @storm_single_line sl
