source "https://supermarket.getchef.com"

cookbook "nginx"
cookbook "php-fpm"
cookbook "mysql"
cookbook "haproxy"
cookbook "keepalived"
cookbook "mysql-multi"
Dir.glob('./cookbooks/**').each do |path|
  cookbook File.basename(path), path: path
end