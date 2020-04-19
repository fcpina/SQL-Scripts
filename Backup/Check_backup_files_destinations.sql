USE [msdb]
GO

-- =============================================
-- Created by: Filipe Pina
-- Description: Check backup files Destinations
-- ============================================= 

SELECT	database_name, name,backup_start_date, datediff(mi, backup_start_date, backup_finish_date) [tempo (min)],
		position, server_name, recovery_model, isnull(logical_device_name, ' ') logical_device_name, device_type, 
		type, cast(backup_size/1024/1024 as numeric(15,2)) [Size (MB)], B.is_copy_only, physical_device_name
FROM msdb.dbo.backupset B
	  INNER JOIN msdb.dbo.backupmediafamily BF ON B.media_set_id = BF.media_set_id
where backup_start_date >=  dateadd(hh, -24 ,getdate()  )
  and type in ('D','I')
 and database_name = 'Northwind' -- database name
 and device_type = 2
order by backup_start_date desc
