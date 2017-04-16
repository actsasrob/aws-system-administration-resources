wget --quiet http://apt.puppet.com/puppetlabs-release-pc1-yakkety.deb
sudo dpkg -i puppetlabs-release-pc1-yakkety.deb
sudo apt update
# Should not be installed, but just in case we caught you using an old instance...
sudo apt remove --yes puppet puppet-common
# Install latest version of puppet from PuppetLabs repo
sudo apt install --yes puppet facter -t yakkety
#install the stdlib module
sudo puppet module install puppetlabs-stdlib
rm puppetlabs-release-pc1-yakkety.deb
