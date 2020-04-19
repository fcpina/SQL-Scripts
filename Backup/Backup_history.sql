-- =============================================
-- Created by: Filipe Pina
-- Description: Query to check the history of Backups that were run
-- ============================================= 

SELECT	database_name, name,backup_start_date, backup_finish_date,datediff(mi, backup_start_date, backup_finish_date) [time (min)], server_name, recovery_model, physical_device_name ,
CASE 
	WHEN device_type = 2 THEN 'Disk'
	WHEN device_type = 3 THEN 'Diskette (obsolete)'
	WHEN device_type = 5 THEN 'Tape'
	WHEN device_type = 6 THEN 'Pipe (obsolete)'
	WHEN device_type = 7 THEN 'Virtual device (for optional use by third-party backup vendors)'
END AS [Device Type], 
CASE	
	WHEN type = 'D' THEN 'Full' 
	WHEN type = 'I' THEN 'Diferencial'
	WHEN type = 'L' THEN 'Log' 
END AS [Backup Type], 
cast(backup_size/1024/1024 as numeric(15,2)) [Size (MB)], B.is_copy_only
FROM msdb.dbo.backupset B
	  INNER JOIN msdb.dbo.backupmediafamily BF ON B.media_set_id = BF.media_set_id
where backup_start_date >=  dateadd(hh, -24 ,getdate()  )
  --and type in ('D','L')
   and device_type IN(2, 3, 5, 6)
--	and database_name = 'Database Name'
order by database_name desc

--	D = FULL, I = Diferencial, L = Log


/*
https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-backup-devices-transact-sql


column device_type

2 = Disk

3 = Diskette (obsolete)

5 = Tape

6 = Pipe (obsolete)

7 = Virtual device (for optional use by third-party backup vendors)

Typically, only disk (2) and tape (5) are used.

De <https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-backup-devices-transact-sql> 
*/