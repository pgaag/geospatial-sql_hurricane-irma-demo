SELECT 
      [huricane_radii]
  FROM [dvadb].[geo].[irma_radii]
  UNION ALL
SELECT geography::UnionAggregate(county_shape)
FROM geo.florida_counties
