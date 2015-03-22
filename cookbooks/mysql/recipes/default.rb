#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not

#template '/etc/my.cnf' do
#  owner 'root'
#  group 'root'
#  mode 644
#  notifies :restart, "service[mysqld]"
#end

execute "set global ruby" do
  command "yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"
  action :run
end

%w(mysql mysql-devel mysql-server).each do |pkg|
  package pkg do
    action :install
  end
end

service "mysqld" do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end

execute "create database" do
  command "mysql -u root -e 'CREATE DATABASE intern2015;'"
  only_if "mysql -u root -e 'show databases;'"
end
