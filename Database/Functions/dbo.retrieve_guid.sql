SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[retrieve_guid] () RETURNS NVARCHAR(38)
BEGIN
  RETURN(SELECT guidstr from dbo.SDE_generate_guid )
END
GO
GRANT EXECUTE ON  [dbo].[retrieve_guid] TO [public]
GO
