# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
  end

  config.vm.provider :parallels do |parallels, override|
    override.vm.box = "parallels/ubuntu-14.04"
  end

  project = 'default'

  config.vm.synced_folder ".", "/var/www/#{project}.dev", :nfs => true
  config.vm.hostname = "#{project}.dev"
  # SSH options.
  config.ssh.insert_key = false
  config.ssh.forward_agent  = true
  config.vm.network :private_network, ip: "192.168.88.96"

  # Extra configuration for parallels.
  $script = <<SCRIPT
echo Installing software-properties-common
sudo apt-get install -y software-properties-common
echo Installing curl
sudo apt-get install -y curl
SCRIPT
  if ENV['VAGRANT_DEFAULT_PROVIDER'] == 'parallels'
    config.vm.provision "shell", inline: $script
  end

  config.vm.provision "shell" do |s|
    s.path = "sysfiles/build.sh"
    s.args = ["#{project}"]
  end

  # Make diskspace easy to compress -- for non-parallels machines.
  $script = <<SCRIPT
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY
SCRIPT
  if ENV['VAGRANT_DEFAULT_PROVIDER'] != 'parallels'
    config.vm.provision "shell", inline: $script
  end

end
