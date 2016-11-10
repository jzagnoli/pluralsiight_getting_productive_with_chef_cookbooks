#
# Cookbook Name:: webapplinux
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'apt::default'
include_recipe 'webapplinux::user'
include_recipe 'firewall::default'
include_recipe 'webapplinux::webserver'
include_recipe 'webapplinux::database'
