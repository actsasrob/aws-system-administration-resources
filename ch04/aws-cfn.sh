#!/bin/bash

# Credit to: https://gist.github.com/cgswong/1ab591eaf813f987622dc2dab9a54648

# Setup CentOS 7 host with cfn-bootstrap python packages installed to support using of CloudFormation cfn-init, cfn-hup, etc helper scripts.

# Update base OS update, and install EPEL repo and Python Pip
sudo yum -y update
sudo yum –y install epel-release
sudo yum -y install python-pip

# Install Python add-ons:
sudo pip install pystache 
sudo pip install argparse
sudo pip install python-daemon
sudo pip install requests

# Install CFN-BootStrap from source
curl -sSL https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz | sudo tar -xzpf -C - /opt
cd /opt/aws-cfn-bootstrap-1.4/
sudo python setup.py build
sudo python setup.py install
# Configure CFN
sudo ln -s /usr/init/redhat/cfn-hup /etc/init.d/cfn-hup
sudo chmod 775 /usr/init/redhat/cfn-hup
cd /opt
sudo mkdir aws
cd aws
sudo mkdir bin
sudo ln -s /usr/bin/cfn-hup /opt/aws/bin/cfn-hup
sudo ln -s /usr/bin/cfn-init /opt/aws/bin/cfn-init
