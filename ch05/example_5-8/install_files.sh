#!/bin/bash

TARGET_DIR=/etc/puppetlabs/code/environments/production

sudo mkdir -p $TARGET_DIR/modules/myblog/{manifests,modules}
sudo cp -f myblog/puppet/manifests/*.pp $TARGET_DIR/manifests
sudo cp -f myblog/puppet/modules/myblog/manifests/*.pp $TARGET_DIR/modules/myblog/manifests

echo "Puppet apply command: sudo puppet apply ${TARGET_DIR}/manifests/site_notec2.pp"
