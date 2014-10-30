# Why do we need this hack?
# from mysql-multi/recipes/default.rb:42
#
# serverid = IPAddr.new node['ipaddress']
#
# ipaddress is picked automatically and always uses
# the brigded IP 10.0.2.15 - on both machines
# This ends up on the same server_id in my.cnf
# and crashes the replication
# Will most likely happen only in vagrant environments

include_recipe "mysql-multi::mysql_master"

script "replace_server_id" do
    interpreter "bash"
    user "root"
    code <<-EOH
sed -i 's/server_id\ =.*/server_id = 1/' /etc/mysql/conf.d/my.cnf
/etc/init.d/mysqld restart
mysql -u root --password=zendcon2014 -e "INSERT INTO mysql.user (Host,USER) VALUES ('10.0.0.20','haproxy'); FLUSH PRIVILEGES;"
mysql -u root --password=zendcon2014 -e "INSERT INTO mysql.user (Host,USER) VALUES ('10.0.0.25','haproxy'); FLUSH PRIVILEGES;"
EOH
end

