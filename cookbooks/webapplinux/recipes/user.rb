#
# Cookbook Name:: webapplinux
# Recipe:: user
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

group node['webapplinux']['group']

user  node['webapplinux']['user'] do
    group node['webapplinux']['group']
    system true
    shell '/bin/bash/'
end
