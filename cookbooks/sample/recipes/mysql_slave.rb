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

include_recipe "mysql-multi::mysql_slave"

script "replace_server_id" do
    interpreter "bash"
    user "root"
    code <<-EOH
sed -i 's/server_id\ =.*/server_id = 2/' /etc/mysql/conf.d/my.cnf
/etc/init.d/mysqld restart
EOH
end

script "register_master_and_start_slave" do
    interpreter "bash"
    user "root"
    code <<-EOH
mysql -u root --password=zendcon2014 -e "change master to master_host='10.0.0.40', master_user='replicant', master_password='zendcon2014', master_log_file='mysql-bin.000001', master_log_pos=120;"
mysql -u root --password=zendcon2014 -e "start slave"
EOH
end