#
# Cookbook Name:: webapplinux
# Recipe:: database
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Configure mysql2 Ruby gem
mysql2_chef_gem 'default' do
  action :install
end

# Configure MySQL client
mysql_client 'default' do
  action :create
end

# Load the secrets file
password_secret = Chef::EncryptedDataBagItem.load_secret(node['webapplinux']['password']['secret_path'])
root_password_databag_item = Chef::EncryptedDataBagItem.load('credentials', 'sql_server_root_password',password_secret)

# Configure MySQL service
mysql_service 'default' do
  initial_root_password root_password_databag_item['password']
  action [:create, :start]
end

# Create database.
mysql_database node['webapplinux']['database']['dbname'] do
  connection(
      :host => node['webapplinux']['database']['host'],
      :username => node['webapplinux']['database']['username'],
      :password => root_password_databag_item['password']
  )
  action :create
end

# Decrypt db_admin password
user_password_databag_item = Chef::EncryptedDataBagItem.load('credentials', 'db_admin_password',password_secret)


# Create database user.
mysql_database_user node['webapplinux']['database']['app']['username'] do
  connection(
      :host => node['webapplinux']['database']['host'],
      :username => node['webapplinux']['database']['username'],
      :password => root_password_databag_item['password']
  )
  password user_password_databag_item['password']
  database_name node['webapplinux']['database']['dbname']
  host node['webapplinux']['database']['host']
  action [:create, :grant]
end

# Write seed file to filesystem.
cookbook_file node['webapplinux']['database']['seed_file'] do
  source 'create-tables.sql'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

# Seed MySQL database and test data.
execute 'initialize database' do
  command "mysql -h #{node['webapplinux']['database']['host']} -u#{node['webapplinux']['database']['app']['username']} -p#{user_password_databag_item['password']} -D #{node['webapplinux']['database']['dbname']} < #{node['webapplinux']['database']['seed_file']}"
  not_if  "mysql -h #{node['webapplinux']['database']['host']} -u#{node['webapplinux']['database']['app']['username']} -p#{user_password_databag_item['password']} -D #{node['webapplinux']['database']['dbname']} -e 'describe customers;'"
  action :run
end