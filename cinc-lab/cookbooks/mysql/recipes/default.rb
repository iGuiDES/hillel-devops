#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2024, The Authors, All Rights Reserved.

package 'mysql-server'

service 'mysql' do
  action [:enable, :start]
end

template '/etc/mysql/my.cnf' do
  source 'my.cnf.erb'
  owner 'mysql'
  group 'mysql'
  mode '0644'
  notifies :restart, 'service[mysql]', :immediately
end

