SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_pinfo_def_update] @sdeIdVal INTEGER, @rcountVal INTEGER,     @wcountVal INTEGER, @opcountVal INTEGER, @numlocksVal INTEGER,     @fb_partialVal INTEGER, @fb_countVal INTEGER, @fb_fcountVal INTEGER,     @fb_kbytesVal INTEGER AS SET NOCOUNT ON     BEGIN TRAN pinfo_tran     UPDATE dbo.SDE_process_information  SET rcount = @rcountVal, wcount = @wcountVal,     opcount = @opcountVal, numlocks = @numlocksVal,      fb_partial = @fb_partialVal, fb_count = @fb_countVal,     fb_fcount = @fb_fcountVal, fb_kbytes = @fb_kbytesVal     WHERE sde_id = @sdeIdVal     COMMIT TRAN pinfo_tran
GO
GRANT EXECUTE ON  [dbo].[SDE_pinfo_def_update] TO [public]
GO
