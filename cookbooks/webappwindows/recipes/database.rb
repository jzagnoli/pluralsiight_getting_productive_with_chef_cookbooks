#
# Cookbook Name:: webappwindows
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install SQL Server
include_recipe 'sql_server::server'

# Create database, table and customer database
# Craete a path to create-database.sql in Chef cache
create_database_script_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'create-database.sql'))

# Copy create-database.sql from cookbook to Chef cache
cookbook_file create_database_script_path do
    source 'create-database.sql'
end

# Get path to SQL Server PowerShell module
sqlps_module_path = ::File.join(ENV['programfiles(x86)'], 'Microsoft SQL Server\110\Tools\PowerShell\Modules\SQLPS')

# Run the SQL file, but only if learnchef database has not been created
powershell_script 'Initialize database' do
    code <<-EOH
    Import-Module "#{sqlps_module_path}"
    Invoke-Sqlcmd -InputFile #{create_database_script_path}
    EOH
    guard_interpreter :powershell_script
    only_if <<-EOH
    Import-Module "#{sqlps_module_path}"
    (Invoke-Sqlcmd -Query "SELECT COUNT(*) AS Count FROM sys.databases WHERE name = 'learnchef'").Count -eq 0
    EOH
end

# Run grant-access.sql to give database access to IIS APPOOL\Products
# Create path to file in Chef cache
grant_access_script_path = win_friendly_path(File.join(Chef::Config[:file_cache_path], 'grant-access.sql'))

# Copy grant-access.sql to Chef cache
cookbook_file grant_access_script_path do
  source 'grant-access.sql'
end

# Run grant_access.sql if IIS APPOOL\Products does not already have access
powershell_script 'Grant SQL access to IIS APPPOOL\Products' do
  code <<-EOH
  Import-Module "#{sqlps_module_path}"
  Invoke-Sqlcmd -InputFile #{grant_access_script_path}
  EOH
  guard_interpreter :powershell_script
  not_if <<-EOH
  Import-Module "#{sqlps_module_path}"
  $sp = Invoke-Sqlcmd -Database learnchef -Query "EXEC sp_helpprotect @username = 'IIS APPPOOL\\Products', @name = 'customers'"
  ($sp.ProtectType.Trim() -eq 'Grant') -and ($sp.Action.Trim() -eq 'Select')
  EOH
end
