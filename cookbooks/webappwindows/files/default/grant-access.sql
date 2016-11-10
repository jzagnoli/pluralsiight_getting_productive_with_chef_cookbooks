USE master;
GO
USE learnchef;
GO
-- Allow Windows user 'IIS APPPOOL\Products' login rights
CREATE LOGIN [IIS APPPOOL\Products] FROM Windows
GO
-- Create matching SQL user
CREATE USER [IIS APPPOOL\Products]
GO
-- Grant query access to new user
GRANT SELECT ON customers TO [IIS APPPOOL\Products]
GO