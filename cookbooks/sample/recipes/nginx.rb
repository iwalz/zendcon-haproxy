include_recipe "nginx::source"

%w(public logs).each do |dir|
  directory "#{node.app.web_dir}/#{dir}" do
    owner node.user.name
    mode "0755"
    recursive true
  end
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "nginx.conf.erb"
  mode "0644"
end

nginx_site "#{node.app.name}.conf"

template "#{node.app.web_dir}/public/index.html" do
  source "index.html.erb"
  owner node.user.name
end

cookbook_file "#{node.app.web_dir}/public/phpinfo.php" do
  source "phpinfo.php"
  owner node.user.name
end