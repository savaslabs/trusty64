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

  project = 'default'

  config.vm.synced_folder ".", "/var/www/#{project}.dev", :nfs => true
  config.vm.hostname = "#{project}.dev"
  # SSH options.
  config.ssh.insert_key = false
  config.ssh.forward_agent  = true
  config.vm.network :private_network, ip: "192.168.88.96"
  
  # Adding a package repo for php 5.6 and installing vim and git
  $script = <<SCRIPT
mkdir -p /var/www/#{project}.dev/www/web
echo Updating package repositories on local vm....
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y update
sudo apt-get -y upgrade
echo Installing vim and git....
sudo apt-get -y install vim git
SCRIPT
  config.vm.provision "shell", inline: $script

  # Installing php 5.6, apache2 and mysql
  $script = <<SCRIPT
echo Installing php5.6, apache2 and MySQL...
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server-5.5
sudo apt-get -y install php5 php-pear php-apc php5-curl php5-gd php5-mysql php5-xdebug mysql-common mysql-client-5.5
sudo cp /var/www/#{project}.dev/sysfiles/my.cnf /etc/mysql/my.cnf
sudo service mysql restart
SCRIPT
  config.vm.provision "shell", inline: $script

  # Cleaning up residual packages
  $script = <<SCRIPT
  sudo apt-get -y autoremove
SCRIPT
  config.vm.provision "shell", inline: $script

  # Installing Docker
  $script = <<SCRIPT
  echo Installing docker and docker dependencies...
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo cp /var/www/#{project}.dev/sysfiles/docker.list /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get purge lxc-docker
sudo apt-cache policy docker-engine
sudo apt-get install -y linux-image-extra-$(uname -r)
sudo apt-get install -y docker-engine
SCRIPT
  config.vm.provision "shell", inline: $script
  # Installing multiverse repo and msttcorefonts
  $script = <<SCRIPT
echo Installing Multiverse repo...
sudo cp /var/www/#{project}.dev/sysfiles/trusty-sources.list /etc/apt/sources.list.d/trusty-sources.list
sudo apt-get update
echo Installing msttcorefonts...
sudo debconf-set-selections <<< 'msttcorefonts msttcorefonts/accepted-mscorefonts-eula select true'
sudo apt-get -y install msttcorefonts
SCRIPT
  config.vm.provision "shell", inline: $script

  # Installing current NodeJS PPA
  $script = <<SCRIPT
echo Installing NodeJS PPA...
curl -sL https://deb.nodesource.com/setup | sudo bash -
echo Installing NodeJS...
sudo apt-get -y install build-essential nodejs xvfb
SCRIPT
  config.vm.provision "shell", inline: $script

  # Installing selenium-standalone
  $script = <<SCRIPT
echo Installing Selenium Standalone and dependencies...
sudo apt-get install -y graphicsmagick openjdk-7-jre-headless firefox fontconfig fonts-liberation fonts-dejavu ttf-dejavu fonts-roboto
sudo npm install phantomjs -g
sudo npm install selenium-standalone@latest -g
SCRIPT
  config.vm.provision "shell", inline: $script
  # Configuring Apache...
  $script = <<SCRIPT
echo Configuring Apache...
sudo cp /var/www/#{project}.dev/sysfiles/mass_virtual.conf /etc/apache2/sites-available/mass_virtual.conf
sudo a2enmod authz_groupfile
sudo a2enmod cgi
sudo a2enmod headers
sudo a2enmod reqtimeout
sudo a2enmod rewrite
sudo a2enmod vhost_alias
sudo a2dissite 000-default
sudo a2dissite default-ssl
sudo a2ensite mass_virtual.conf
sudo service apache2 restart
SCRIPT
  config.vm.provision "shell", inline: $script
  # Installing Composer
$script = <<SCRIPT
echo Installing Composer...
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '41e71d86b40f28e771d4bb662b997f79625196afcca95a5abf44391188c695c6c1456e16154c75a211d238cc3bc5cb47') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
SCRIPT
  config.vm.provision "shell", inline: $script

  #Installing Drupal via Composer Template for Drupal Projects
  $script = <<SCRIPT
echo Installing Drupal Base Install...
cd /var/www/#{project}.dev
rmdir /var/www/#{project}.dev/www/web
composer create-project drupal-composer/drupal-project:8.x-dev www --stability dev --no-interaction
echo Downloading devel module...
cd /var/www/#{project}.dev/www
composer require drupal/devel:8.* 
sudo service apache2 restart
cd /var/www/#{project}.dev/www/web
mysql -u root -proot -e "create database drupal"
mysql -u root -proot -e "grant all on drupal.* to root@localhost identified by 'root'";
../vendor/bin/drush si -y --account-name=admin --account-pass=admin --db-su=root --db-su-pw=root --db-url=mysql://root:root@localhost/drupal --site-name=HPTN
../vendor/bin/drush en devel -y
SCRIPT
#  config.vm.provision "shell", inline: $script
end
