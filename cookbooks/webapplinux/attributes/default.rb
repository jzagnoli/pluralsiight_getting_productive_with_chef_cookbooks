default['webapplinux']['user'] = 'web_admin'
default['webapplinux']['group'] = 'web_admin'

default['webapplinux']['document_root'] = '/var/www/customers/public_html'

default['firewall']['allow_ssh'] = true

default['webapplinux']['password']['secret_path'] = '/etc/chef/encrypted_data_bag_secret'

default['webapplinux']['database']['dbname'] = 'products'
default['webapplinux']['database']['host'] = '127.0.0.1'
default['webapplinux']['database']['username'] = 'root'
default['webapplinux']['database']['app']['username'] = 'db_admin'
default['webapplinux']['database']['seed_file'] = '/tmp/create-tables.sql'



