/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [ID]
      ,[huricane_current_pos].STBuffer(50000)
      ,[metadata_id]
  FROM [dvadb].[geo].[irma_best_track]
