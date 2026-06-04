CREATE TABLE [dbo].[SDE_tables_last_edit_time]
(
[id] [bigint] NOT NULL IDENTITY(1, 1),
[registration_id] [int] NOT NULL,
[edit_moment] [datetime2] (3) NOT NULL CONSTRAINT [gdb_edit_moment_def] DEFAULT (CONVERT([datetime2](3),getutcdate())),
[minx] [float] NULL,
[miny] [float] NULL,
[maxx] [float] NULL,
[maxy] [float] NULL,
[minz] [float] NULL,
[maxz] [float] NULL,
[minm] [float] NULL,
[maxm] [float] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[sde_tables_last_edit_time_insert_tg] ON [dbo].[SDE_tables_last_edit_time] FOR INSERT AS 
BEGIN 
  DECLARE @last_delete_time    DATETIME2 
  DECLARE @curr_moment         DATETIME2 = GETUTCDATE() 
  DECLARE @purge_moment        DATETIME2 
  DECLARE @purge_older_entries INTEGER = 0 
  DECLARE @varbin_context_info VARBINARY(128) 
  DECLARE @context_info        VARCHAR(128) 
  DECLARE @thresh_hold         INTEGER 
  DECLARE @delimiter           INTEGER 
  DECLARE @diff_time           INTEGER 

  SELECT @context_info = CAST(CONTEXT_INFO AS VARCHAR(128)) 
    FROM sys.dm_exec_requests WHERE session_id = @@SPID

  IF substring (@context_info, 1, 9) = 'last_edit' 
  BEGIN 
    SET @delimiter = charindex (';', @context_info, 11) 
    IF @delimiter > 0 
      SET @last_delete_time = CAST (substring (@context_info, 11, @delimiter-11) AS DATETIME2) 
    ELSE 
      SET @last_delete_time = CAST (substring (@context_info, 11, LEN(@context_info)-11) AS DATETIME2) 
  END 

  IF @last_delete_time IS NULL 
  BEGIN 
    SET @purge_older_entries = 1 
  END 
  ELSE 
  BEGIN 
    SET @diff_time = DATEDIFF(minute, @last_delete_time, @curr_moment) 
    IF @diff_time > 5  /* in minutes */ 
      SET @purge_older_entries = 1 
  END 

  IF @purge_older_entries > 0 
  BEGIN 
   DECLARE @ret_code INTEGER 
   SET @delimiter = charindex('thresh_hold', @context_info, 1) 
   IF @delimiter > 0 
     SET @thresh_hold = CAST (substring (@context_info,  @delimiter+12, 10) AS INTEGER) 

   EXEC @ret_code = sp_getapplock '1769108293', 'Exclusive', 'Transaction', 0 
   IF @ret_code >= 0 
   BEGIN 
     IF @thresh_hold IS NOT NULL 
       SET @purge_moment = DATEADD(minute, 0-@thresh_hold, @curr_moment) 
     ELSE 
       SET @purge_moment = DATEADD(minute, -1, @curr_moment) 

     -- Delete all rows that are older than 'purge_moment' for registration_id. 
     -- However, keep at least one (the latest entry) for each unique 
     -- registration_id even if they are older than 'purge_moment'. 
     DELETE FROM DBO.SDE_TABLES_LAST_EDIT_TIME 
          WHERE id IN 
                (SELECT id 
                   FROM (SELECT id, 
                                ROW_NUMBER() OVER (PARTITION BY registration_id 
                                                       ORDER BY edit_moment DESC) AS rn 
                           FROM DBO.SDE_TABLES_LAST_EDIT_TIME 
                          WHERE edit_moment < @purge_moment 
                        ) foo 
                  WHERE foo.rn != 1) 
   END 
   /* Save last_delete_time and thresh_hold */ 
   SET @context_info = 'last_edit,' + CAST (@curr_moment AS VARCHAR(27)) 
   IF @thresh_hold is NOT NULL 
     SET @context_info = @context_info + ';thresh_hold,' + CAST(@thresh_hold AS VARCHAR(10)) 
   SET @varbin_context_info = CAST (@context_info AS VARBINARY(128)) 
   SET CONTEXT_INFO @varbin_context_info 
  END 
END
GO
CREATE NONCLUSTERED INDEX [edit_moment_ix] ON [dbo].[SDE_tables_last_edit_time] ([edit_moment]) INCLUDE ([id], [registration_id]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [tbls_last_edit_ix] ON [dbo].[SDE_tables_last_edit_time] ([registration_id], [edit_moment]) WITH (ALLOW_PAGE_LOCKS=OFF) ON [PRIMARY]
GO
GRANT DELETE ON  [dbo].[SDE_tables_last_edit_time] TO [public]
GO
GRANT INSERT ON  [dbo].[SDE_tables_last_edit_time] TO [public]
GO
GRANT SELECT ON  [dbo].[SDE_tables_last_edit_time] TO [public]
GO
GRANT UPDATE ON  [dbo].[SDE_tables_last_edit_time] TO [public]
GO
ALTER TABLE [dbo].[SDE_tables_last_edit_time] SET ( LOCK_ESCALATION = DISABLE )
GO
