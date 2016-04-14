#!/bin/bash

# Set up project dir
mkdir -p /var/www/$1.dev/www/web

# Adding a package repo for php 5.6 and installing vim and git
echo Updating package repositories on local vm....
sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get -y update
sudo apt-get -y upgrade
echo Installing vim and git....
sudo apt-get -y install vim git

# Installing php 5.6, apache2 and mysql
echo "Installing php5.6, apache2 and MySQL..."
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server-5.5
sudo apt-get -y install php5 php-pear php-apc php5-curl php5-gd php5-mysql php5-xdebug mysql-common mysql-client-5.5
sudo cp /var/www/$1.dev/sysfiles/my.cnf /etc/mysql/my.cnf
sudo service mysql restart

# Cleaning up residual packages
sudo apt-get -y autoremove

# Installing Docker
echo Installing docker and docker dependencies...
sudo apt-get install apt-transport-https ca-certificates
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo cp /var/www/$1.dev/sysfiles/docker.list /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get purge lxc-docker
sudo apt-cache policy docker-engine
sudo apt-get install -y linux-image-extra-$(uname -r)
sudo apt-get install -y docker-engine

# Installing multiverse repo and msttcorefonts
echo Installing Multiverse repo...
sudo cp /var/www/$1.dev/sysfiles/trusty-sources.list /etc/apt/sources.list.d/trusty-sources.list
sudo apt-get update
echo Installing msttcorefonts...
sudo debconf-set-selections <<< 'msttcorefonts msttcorefonts/accepted-mscorefonts-eula select true'
sudo apt-get -y install msttcorefonts

# Installing current NodeJS PPA
echo Installing NodeJS PPA...
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
echo Installing NodeJS...
sudo apt-get -y install build-essential nodejs xvfb

# Installing selenium-standalone
echo Installing Selenium Standalone and dependencies...
sudo apt-get install -y graphicsmagick openjdk-7-jre-headless firefox fontconfig fonts-liberation fonts-dejavu ttf-dejavu fonts-roboto
sudo npm install phantomjs-prebuilt -g
sudo npm install selenium-standalone@latest -g
sudo npm install --global gulp-cli

# Configuring Apache...
echo Configuring Apache...
sudo cp /var/www/$1.dev/sysfiles/mass_virtual.conf /etc/apache2/sites-available/mass_virtual.conf
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

# Installing Composer
echo Installing Composer...
php -r "readfile('https://getcomposer.org/installer');" > composer-setup.php
php -r "if (hash('SHA384', file_get_contents('composer-setup.php')) === '7228c001f88bee97506740ef0888240bd8a760b046ee16db8f4095c0d8d525f2367663f22a46b48d072c816e7fe19959') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer

# Installing Drupal Console
curl https://drupalconsole.com/installer -L -o drupal.phar
sudo mv drupal.phar /usr/local/bin/drupal
sudo chmod +x /usr/local/bin/drupal
sudo drupal init --override
drupal init --override

# Making box as small as possible after provisioning
sudo apt-get clean
cat /dev/null > ~/.bash_history && history -c && exit

# Installing Drupal via Composer Template for Drupal Projects
echo Installing Drupal Base Install...
cd /var/www/$1.dev
rmdir /var/www/$1.dev/www/web
composer create-project drupal-composer/drupal-project:8.x-dev www --stability dev --no-interaction
echo Downloading devel module...
cd /var/www/$1.dev/www
composer require drupal/devel:8.* 
sudo service apache2 restart
cd /var/www/$1.dev/www/web
mysql -u root -proot -e "create database drupal"
mysql -u root -proot -e "grant all on drupal.* to root@localhost identified by 'root'";
../vendor/bin/drush si -y --account-name=admin --account-pass=admin --db-su=root --db-su-pw=root --db-url=mysql://root:root@localhost/drupal --site-name=HPTN
../vendor/bin/drush en devel -y
