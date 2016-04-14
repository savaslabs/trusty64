# SavasLabs Trusty64 Base box

To build a new base box:

* Clone this repository
* cd to the directory housing the Vagrantfile
* Run `vagrant box update`
* Run `vagrant up`
* Run `vagrant package --output <mynewbox>.box`
* Upload as a new version to https://atlas.hashicorp.com/savas/boxes/trusty64/

If you are building using parallels, your environment variable `VAGRANT_DEFAULT_PROVIDER` **must** be set to `parallels`. This is because the vagrantfile makes it difficult to actually read the provider variable at runtime, so we rely on the `VAGRANT_DEFAULT_PROVIDER` variable as a proxy. Run `export VAGRANT_DEFAULT_PROVIDER="parallels"` before the above steps. See more at https://groups.google.com/forum/#!topic/vagrant-up/XIxGdm78s4I

