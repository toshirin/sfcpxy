
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  odl=ENV['ODL']
  config.ssh.insert_key = false
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"
  end

  num_nodes = (ENV['NUM_NODES'] || 1).to_i

  # ip configuration
  ip_base = (ENV['SUBNET'] || "192.168.50.")
  ips = num_nodes.times.collect { |n| ip_base + "#{n+70}" }

  num_nodes.times do |n|
    config.vm.define "pxysfc#{n+1}", autostart: true do |compute|
      vm_ip = ips[n]
      vm_index = n+1
      compute.vm.box_url = "###Your Directory Here###/sfcpxy.box"
      compute.vm.hostname = "pxysfc#{vm_index}"
      compute.vm.network "private_network", ip: "#{vm_ip}"
      compute.vm.network "private_network", virtualbox__intnet: "net#{n}", auto_config: false
      compute.vm.network "private_network", virtualbox__intnet: "net#{n+1}", auto_config: false
      compute.vm.provider :virtualbox do |vb|
        vb.memory = 512
        vb.customize ["modifyvm", :id, "--ioapic", "on", "--nicpromisc3", "allow-all", "--nicpromisc4", "allow-all"]      
        vb.cpus = 1
      end
    end
  end
end
