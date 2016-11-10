#
# Cookbook Name:: webapplinux
# Recipe:: webserver
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install Apache and starty the Apache service
httpd_service 'customers' do
    mpm 'prefork'
    action [:create, :start]
end

httpd_config 'customers' do
  instance 'customers'
  source 'customers.conf.erb'
  notifies :restart, 'httpd_service[customers]'
end

# Create the document root directory
directory node['webapplinux']['document_root'] do
  recursive true
end

# Load the secrets file
password_secret = Chef::EncryptedDataBagItem.load_secret(node['webapplinux']['password']['secret_path'])
user_password_databag_item = Chef::EncryptedDataBagItem.load('credentials', 'db_admin_password',password_secret)

# Create a default home page
template "#{node['webapplinux']['document_root']}/index.php" do
  source 'index.php.erb'
  owner node['webapplinux']['user']
  group node['webapplinux']['group']
  mode '0644'
  action :create
  variables({
      :database_password => user_password_databag_item['password']
  })
end

# Open TCP port 80 for web traffic
firewall_rule 'http' do
  port 80
  protocol :tcp
  action :create
end

# Install mod_php5 Apache module.
httpd_module 'php5' do
  instance 'customers'
end

# Install php5_mysql.
package 'php5-mysql' do
  action :install
  notifies :restart, 'httpd_service[customers]'
end