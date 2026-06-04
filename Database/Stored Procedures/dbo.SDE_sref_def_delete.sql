SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_sref_def_delete]       @sridVal INTEGER AS SET NOCOUNT ON DELETE FROM dbo.SDE_spatial_references WHERE srid = @sridVal
GO
GRANT EXECUTE ON  [dbo].[SDE_sref_def_delete] TO [public]
GO
