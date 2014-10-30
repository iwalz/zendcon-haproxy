name 'sample'
maintainer 'Ingo Walz'
maintainer_email 'ingo.walz@googlemail.com'
license 'Apache 2.0'
description 'Installs/Configures sample app'

recipe "sample", "Installs nginx"

depends 'haproxy'
depends 'nginx'
depends 'keepalived'
depends 'mysql-multi'