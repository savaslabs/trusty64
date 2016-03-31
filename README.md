# SavasLabs Trusty64 Base box with PHP7.0 -- currently broken!

Note:  There is a problem with the package repository that houses PHP7.0, there are missing configuration files, and as a result Apache, the apache php libraries and php-cli does not install.  This is here for future work in the event that these issues get resolved, we can use this to build an Ubuntu Trusty box with PHP7.0
To build a new base box:

* clone this repository
* cd to the directory housing the Vagrantfile
* run "vagrant box update"
* run "vagrant up"
* shell into the VM with "vagrant ssh"
* run "sudo apt-get clean"
* run "sudo dd if=/dev/zero of=/EMPTY bs=1M" (note, this step will take a while, up to 10 minutes)
* run "sudo rm -f /EMPTY"
* run "cat /dev/null > ~/.bash_history && history -c && exit" (this will exit you from the vm back to your host environment)
* run "vagrant package --output <mynewbox>.box"
* upload as a new version to https://atlas.hashicorp.com/savas/boxes/trusty64/

