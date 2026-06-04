SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_pinfo_def_insert]
 @sdeIdVal INTEGER,
  @serverIdVal INTEGER,
 @directConnectVal VARCHAR(1),
 @sysnameVal NVARCHAR(32),
 @nodenameVal NVARCHAR(256),
 @xdrneededVal VARCHAR(1),
 @tablenameVal NVARCHAR(95) AS SET NOCOUNT ON
 DECLARE @current_user NVARCHAR(128)
 -- Clean up invalid connections.
 DELETE FROM dbo.SDE_process_information WHERE spid = @@spid AND table_name <> @tablenameVal 
 BEGIN TRAN pinfo_tran
 EXECUTE dbo.SDE_get_current_user_name @current_user OUTPUT
 INSERT INTO dbo.SDE_process_information (sde_id,spid,server_id,start_time,
    rcount,wcount,opcount,numlocks,fb_partial,fb_count,fb_fcount,
    fb_kbytes,owner,direct_connect,sysname,nodename,xdr_needed,table_name)
 VALUES (@sdeIdVal,@@spid,@serverIdVal,getdate(),0,0,0,0,0,0,0,0,
    @current_user,@directConnectVal,@sysnameVal,@nodenameVal,
    @xdrneededVal,@tablenameVal)
 DELETE FROM dbo.SDE_lineages_modified 
    WHERE DATEDIFF (day, time_last_modified, getdate()) > 2
 COMMIT TRAN pinfo_tran

GO
GRANT EXECUTE ON  [dbo].[SDE_pinfo_def_insert] TO [public]
GO
