#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "/etc/yum.repos.d/nginx.repo" do
  source "nginx.repo"
  mode 0644
end

package "nginx" do
  action :install
  options "--enablerepo=nginx"
end

service "nginx" do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end

template "nginx.conf" do
  path "/etc/nginx/conf.d/default.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end
