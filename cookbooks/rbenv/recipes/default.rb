#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{make gcc zlib-devel openssl-devel readline-devel ncurses-devel gdbm-devel libffi-devel tk-devel libyaml-devel}.each do |pkg|
  yum_package pkg do
    action :install
  end 
end

git "/usr/local/rbenv" do                                                                                                                                                         
  repository "git://github.com/sstephenson/rbenv.git"
  reference "master"
  action :checkout
  user "root"
end

template "/etc/profile.d/rbenv.sh" do
  owner "root"
  mode 0644
end

directory "/usr/local/rbenv/plugins" do
  owner "root"
  mode "0755"
  action :create
end

execute "install ruby 2.1.0" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv versions | grep 2.1.0"
  command "source /etc/profile.d/rbenv.sh; rbenv install 2.1.0"
  action :run
end

execute "set global ruby" do
  not_if "source /etc/profile.d/rbenv.sh; rbenv global | grep 2.1.0"
  command "source /etc/profile.d/rbenv.sh; rbenv global 2.1.0; rbenv rehash"
  action :run
end
