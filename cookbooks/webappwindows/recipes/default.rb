#
# Cookbook Name:: webappwindows
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'webappwindows::webserver'
include_recipe 'webappwindows::database'