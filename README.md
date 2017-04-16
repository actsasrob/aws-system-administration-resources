aws-system-administration
=========================

## Sample code and examples for AWS System Administration

## ch04

### Puppet client/master CloudFormation templates

The CloudFormation scripts below, provided by the book authors, demonstrate using CloudFormation to automate process to create Puppet master and client ec2 instances:
* puppet_client_cloudformation.json
* puppet_client_cloudformation_WITH_MARKUP.json
* puppet_master_client_manual_install_cloudformation.json

### packer_example
packer_example directory contains a working example of using packer to build an AMI image with puppet 4.x packages pre-installed and with a site.pp manifest and nginx module definition to install nginx as the default node type. The base AMI Ubuntu 17.10 "yakkety yak" is used because there is a puppetlabs repo available that provides Puppet 4.x packages.

### Puppet masterless client example

* puppet_client_masterless_cloudformation.json - CloudFormation template to build Nginx server using masterless Puppet 4.x client. Uses base CentOS 7 AMI that installs Puppet agent 4.x packages and then installs default Puppet site.pp manifest and custom Nginx module. The masterless Puppet client is used to bootstrap a running installation of Nginx at the time the EC2 instance boots. NOTE: CloudFormation cfn\* bootstrap scripts are not installed by default on CentOS. The UserData section contains shell commands to install the python cfn-bootstrap package to enable use of cfn-init, cfn-hup, etc.
  * puppet_client_masterless_cloudformation.sh - bash shell script to execute 'aws cloudformation' CLI to create Nginx EC2 instance using above CloudFormation script. 

### aws-cfn.sh
Setup CentOS 7 host with cfn-bootstrap python packages installed to support using of CloudFormation cfn-init, 
cfn-hup, etc helper scripts.

TODO:
Update ch04/puppet_client_masterless_cloudformation.json to use amazon linux or CentOS7 instance and pull down Puppet4 repo from puppetlabs


