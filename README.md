# SavasLabs Trusty64 Base box

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

If you are building using parallels, your environment variable `VAGRANT_DEFAULT_PROVIDER` **must** be set to `parallels`. This is because the vagrantfile makes it difficult to actually read the provider variable at runtime, so we rely on the `VAGRANT_DEFAULT_PROVIDER` variable as a proxy. Run `export VAGRANT_DEFAULT_PROVIDER="parallels"` before the above steps. See more at https://groups.google.com/forum/#!topic/vagrant-up/XIxGdm78s4I

