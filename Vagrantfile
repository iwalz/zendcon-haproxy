servers = {
    "nginx1"        => {
        "ip"        => "10.0.0.10",
        "hostname"  => "nginx1",
        "memory"    => 1024,
        "config"    => "nginx.json",
        "forward"   => { 80 => 8080 }
    },
    "nginx2"        => {
        "ip"        => "10.0.0.15",
        "hostname"  => "nginx2",
        "memory"    => 1024,
        "config"    => "nginx.json"
    },
    "haproxy1"      => {
        "ip"        => "10.0.0.20",
        "hostname"  => "haproxy1",
        "memory"    => 1024,
        "config"    => "haproxy1.json",
        "forward"   => { 80 => 8081 }
    },
    "haproxy2"      => {
        "ip"        => "10.0.0.25",
        "hostname"  => "haproxy2",
        "memory"    => 1024,
        "config"    => "haproxy2.json"
    },
    "mysql1"        => {
        "ip"        => "10.0.0.40",
        "hostname"  => "mysql1",
        "memory"    => 1024,
        "config"    => "mysql1.json"
    },
    "mysql2"        => {
        "ip"        => "10.0.0.45",
        "hostname"  => "mysql2",
        "memory"    => 1024,
        "config"    => "mysql2.json"
    }
}

Vagrant.configure("2") do |vagrant|

  vagrant.vm.box = "opscode-centos65"
  vagrant.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"

  servers.each do |server, conf|
    vagrant.vm.define server do |box|
        vagrant.vm.provider "virtualbox" do |vb|
            vb.customize ["modifyvm", :id, "--memory", conf["memory"]]
        end

        # Plugins
        vagrant.berkshelf.enabled = true
        vagrant.omnibus.chef_version = :latest

        box.vm.network "private_network", ip: conf["ip"]
        box.vm.box = "opscode-centos65"
        box.vm.hostname = conf["hostname"]
        box.vm.provision :shell, :inline => "hostname " + conf["hostname"]
        if conf.has_key?("forward")
            conf["forward"].each do |source,dest|
                box.vm.network "forwarded_port", guest: source, host: dest
            end
        end

        #Set hostnames in /etc/hosts
        servers.each do |s, c|
            box.vm.provision :shell, :inline => "echo '" + c["ip"] + " " + c["hostname"] + "' >> /etc/hosts"
        end

        # Chef solo provisioning
        vagrant.vm.provision :chef_solo do |chef|
            if conf.has_key?("config")
                chef.json = JSON.parse(File.read(File.dirname(__FILE__) + "/" + conf["config"]))
            end
        end
    end
  end
end