#!/bin/bash

TARGET_DIR=/etc/puppetlabs/code/environments/production

echo "Installing required puppet modules..."
#sudo puppet module install puppetlabs-stdlib --version 4.16.0
#sudo puppet module install puppetlabs-concat --version 2.2.1
#sudo puppet module install ajcrowe-supervisord --version 0.6.1
#sudo puppet module install jfryman-nginx --version 0.3.0

echo "Installing custom modules/manifests..."
sudo mkdir -p $TARGET_DIR/modules
sudo cp -r -f --dereference puppet/modules/* $TARGET_DIR/modules
#sudo mkdir -p $TARGET_DIR/modules/myblog/{manifests,modules,templates,files}
sudo cp -f --dereference puppet/manifests/*.pp $TARGET_DIR/manifests
#sudo cp -f puppet/modules/myblog/manifests/*.pp $TARGET_DIR/modules/myblog/manifests

echo "Puppet apply command: sudo puppet apply ${TARGET_DIR}/manifests/site.pp"
