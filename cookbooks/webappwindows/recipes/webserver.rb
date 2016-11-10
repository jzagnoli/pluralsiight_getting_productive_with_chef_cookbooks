#
# Cookbook Name:: webappwindows
# Recipe:: webserver
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# Enagle the IIS role
dsc_script "Web-Server" do
    code <<-EOH
    WindowsFeature InstallWebServer
    {
        Name = "Web-Server"
        Ensure = "Present"
    }
    EOH
end

# Install ASP.NET 4.5
dsc_script "Web-Asp-Net45" do
    code <<-EOH
    WindowsFeature InstallAspDotNet45
    {
        Name = "WWeb-Asp-Net45"
        Ensure = "Present"
    }
    EOH
end

# Install IIS Management Console
dsc_script "Web-Mgmt-Console" do
    code <<-EOH
    WindowsFeature InstallIISConsole
    {
        Name = "Web-Mgmt-Console"
        Ensure = "Present"
    }
    EOH
end

# Remove IIS default web site
include_recipe 'iis::remove_default_site'

iis_site 'Default Web Site' do
  action [:stop, :delete]
end

iis_pool 'DefaultAppPool' do
  action [:stop, :delete]
end

# Define web app and site locations
app_directory = 'C:\inetpub\apps\Customers'
site_directory = 'C:\inetpub\sites\Customers'

# Download pre-built Customers application and extract package
windows_zipfile app_directory do
  source 'https://github.com/learn-chef/customers-web-app-aspnet/releases/download/v0.1.0/Customers.zip'
  action :unzip
  not_if { ::File.exists?(app_directory) }
end


# Create Products application pool
iis_pool 'Products' do
  runtime_version '4.0'
  action :add
end

# Create site directory and assign rights to IIS_IUSRS
directory site_directory do
  rights :read, 'IIS_IUSRS'
  recursive true
  action :create
end

# Create Customers web site
iis_site 'Customers' do
  protocol :http 
  port 80
  path site_directory
  application_pool 'Products'
  action [:add, :start]
end

# Create Customers web application
iis_app 'Customers' do
  application_pool 'Products'
  path '/Products'
  physical_path app_directory
  action :add
end
