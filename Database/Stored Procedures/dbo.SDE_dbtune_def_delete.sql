SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_dbtune_def_delete]       @keywordVal NVARCHAR(32),@parameter_nameVal NVARCHAR(32)       AS SET NOCOUNT OFF IF (@parameter_nameVal IS NULL)        DELETE FROM dbo.SDE_dbtune WHERE keyword = @keywordVal      ELSE DELETE FROM dbo.SDE_dbtune WHERE keyword = @keywordVal AND           parameter_name = @parameter_nameVal
GO
GRANT EXECUTE ON  [dbo].[SDE_dbtune_def_delete] TO [public]
GO
