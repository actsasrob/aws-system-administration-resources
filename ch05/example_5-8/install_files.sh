#!/bin/bash

TARGET_DIR=/etc/puppetlabs/code/environments/production

sudo mkdir -p $TARGET_DIR/modules/myblog/{manifests,modules}
sudo cp -f myblog/puppet/manifests/*.pp $TARGET_DIR/manifests
sudo cp -f myblog/puppet/modules/myblog/manifests/*.pp $TARGET_DIR/modules/myblog/manifests
