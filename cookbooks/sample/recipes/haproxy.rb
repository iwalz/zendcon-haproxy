include_recipe "haproxy::install_source"

#Place template as config
template "#{node['haproxy']['conf_dir']}/haproxy.cfg" do
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode "644"
end

#And add SSL certificate to filesystem
cookbook_file "sample.pem" do
    path "#{node['haproxy']['conf_dir']}/sample.pem"
    action :create_if_missing
end

#Create pages directory
directory "#{node['haproxy']['conf_dir']}/pages/" do
    recursive true
    action :create
end

#And place poodle page in it
cookbook_file "poodle.http" do
    path "#{node['haproxy']['conf_dir']}/pages/poodle.http"
    action :create_if_missing
end

#Start haproxy and enable is as service
service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

#And make it HA
include_recipe 'keepalived'

node.default['keepalived']['check_scripts']['chk_haproxy'] = {
  'script'      => 'killall -0 haproxy',
  'interval'    => 2,
  'weight'      => 2
}

node.default['keepalived']['instances']['virtual'] = {
  'ip_addresses'    => '10.0.0.30',
  'interface'       => 'eth0',
  'track_script'    => 'chk_haproxy',
  'nopreempt'       => false,
  'advert_int'      => 1,
  'auth_type'       => nil,
  'auth_pass'       => 'foo'
}