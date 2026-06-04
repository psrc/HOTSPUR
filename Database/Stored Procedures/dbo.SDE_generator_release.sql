SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SDE_generator_release] AS SELECT 5 FROM dbo.SDE_version
GO
GRANT EXECUTE ON  [dbo].[SDE_generator_release] TO [public]
GO
