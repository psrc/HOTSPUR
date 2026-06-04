SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_pinfo_def_insert_ex]
 @sdeIdVal INTEGER,
  @serverIdVal INTEGER,
 @directConnectVal VARCHAR(1),
 @sysnameVal NVARCHAR(32),
 @nodenameVal NVARCHAR(256),
 @xdrneededVal VARCHAR(1),
 @tablenameVal NVARCHAR(95) AS SET NOCOUNT ON
 BEGIN TRAN pinfo_tran
 DECLARE @current_user NVARCHAR(128)
 EXECUTE dbo.SDE_get_current_user_name @current_user OUTPUT
 INSERT INTO dbo.SDE_process_information (sde_id,spid,server_id,start_time,
    rcount,wcount,opcount,numlocks,fb_partial,fb_count,fb_fcount,
    fb_kbytes,owner,direct_connect,sysname,nodename,xdr_needed,table_name)
 VALUES (@sdeIdVal,@@spid,@serverIdVal,getdate(),0,0,0,0,0,0,0,0,
    @current_user,@directConnectVal,@sysnameVal,@nodenameVal,
    @xdrneededVal,@tablenameVal)
 COMMIT TRAN pinfo_tran

GO
GRANT EXECUTE ON  [dbo].[SDE_pinfo_def_insert_ex] TO [public]
GO
