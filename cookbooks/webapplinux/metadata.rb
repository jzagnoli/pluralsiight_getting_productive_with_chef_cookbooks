name 'webapplinux'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'all_rights'
description 'Installs/Configures webapplinux'
long_description 'Installs/Configures webapplinux'
version '0.3.6'

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Issues` link
# issues_url 'https://github.com/<insert_org_here>/webapplinux/issues' if respond_to?(:issues_url)

# If you upload to Supermarket you should set this so your cookbook
# gets a `View Source` link
# source_url 'https://github.com/<insert_org_here>/webapplinux' if respond_to?(:source_url)

depends 'apt', '~> 2.9.2'
depends 'httpd', '~> 0.3.3'
depends 'firewall', '~> 2.3.0'
depends 'mysql2_chef_gem', '~> 1.0.2'
depends 'mysql', '~> 6.1.2'
depends 'database', '~> 4.0.9'
