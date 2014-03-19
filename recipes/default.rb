#
# Cookbook Name:: newrelic
# Recipe:: default
#
# Copyright 2014, Dwwd Software Inc.
#

# bash 'Add the New Relic apt repository' do
#   user 'root'
#   code <<-EOC
#     echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list
#     wget -O- https://download.newrelic.com/#{node[:newrelic][:key_id]}.gpg | apt-key add -
#     apt-get update
#   EOC
# end

apt_repository 'newrelic' do
  uri          'http://apt.newrelic.com/debian/'
  distribution 'newrelic'
  components   ['non-free']
  key          "https://download.newrelic.com/#{node[:newrelic][:key_id]}.gpg"
  action :add
end

package "newrelic-sysmond" do
  options "--allow-unauthenticated"
  action :upgrade
end

directory "/var/run/newrelic" do
  owner "newrelic"
  group "newrelic"
end

# nrsysmond-config --set license_key=yourkey
template "/etc/newrelic/nrsysmond.cfg" do
  source "nrsysmond.cfg.erb"
  owner "root"
  group "newrelic"
  mode "640"
  variables(
    :license_key => node[:newrelic][:license_key],
    :hostname => node[:newrelic][:hostname]
  )
  notifies(:restart, "service[newrelic-sysmond]") if node[:newrelic][:enabled]
end

# /etc/init.d/newrelic-sysmond start
service "newrelic-sysmond" do
  supports :status => true, :restart => true, :reload => true
  if node[:newrelic][:enabled]
    action [ :enable, :start ]
  else
    action [ :disable, :stop ]
  end
end
