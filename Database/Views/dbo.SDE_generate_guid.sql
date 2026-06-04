SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[SDE_generate_guid] AS 
 SELECT '{' + CONVERT(NVARCHAR(36),newid()) + '}' as guidstr 

GO
GRANT SELECT ON  [dbo].[SDE_generate_guid] TO [public]
GO
