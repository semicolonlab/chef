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

execute "add repo" do
  command "yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"
  action :run
  not_if "which mysql"
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

execute "create user" do
  command "mysql -u root -e 'CREATE USER #{node["mysql"]["user"]}@localhost IDENTIFIED BY \"#{node["mysql"]["password"]}\";'"  
  not_if " mysql -u root -e 'select User from mysql.user where User=\"#{node["mysql"]["user"]}\";'"
end

execute "create database" do
  command "mysql -u root -e 'CREATE DATABASE IF NOT EXISTS #{node["mysql"]["database"]};'"
end

execute "grant all on #{node["mysql"]}to #{node["mysql"]["user"]}" do
  command "mysql -u root -e 'grant ALL on #{node["mysql"]["database"]}.* to '#{node["mysql"]["user"]}'@'localhost';'"
  not_if "mysql -u #{node["mysql"]["user"]} -e 'select * from #{node["mysql"]["database"]};'"
end
