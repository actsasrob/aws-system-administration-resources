aws-system-administration
=========================

## Sample code and examples for AWS System Administration

## ch04

### Puppet client/master CloudFormation templates

The CloudFormation scripts below, provided by the book authors, demonstrate using CloudFormation to automate process to create Puppet master and client EC2 instances:
* puppet_client_cloudformation.json
* puppet_client_cloudformation_WITH_MARKUP.json
* puppet_master_client_manual_install_cloudformation.json

### packer_example
packer_example directory contains a working example of using packer to build an AMI image with puppet 4.x packages pre-installed and with a site.pp manifest and nginx module definition to install nginx as the default node type. The base AMI Ubuntu 17.10 "yakkety yak" is used because there is a puppetlabs repo available that provides Puppet 4.x packages.

The contents of the packer_example directory map to the content found in the **"Building AMIs with Packer"** section of Chapter 4 of the book.

### Puppet masterless client example

* puppet_client_masterless_cloudformation.json - CloudFormation template to build Nginx server using masterless Puppet 4.x client. Uses base CentOS 7 AMI that installs Puppet agent 4.x packages and then installs default Puppet site.pp manifest and custom Nginx module. The masterless Puppet client is used to bootstrap a running installation of Nginx at the time the EC2 instance boots. NOTE: CloudFormation cfn\* bootstrap scripts are not installed by default on CentOS. The UserData section contains shell commands to install the python cfn-bootstrap package to enable use of cfn-init, cfn-hup, etc.
  * puppet_client_masterless_cloudformation.sh - bash shell script to execute 'aws cloudformation' CLI to create Nginx EC2 instance using above CloudFormation script. 
  * *Before running this script update the "--region" option to point to the desired region, update the "AMI" ParameterKey value to point to a CentOS 7 base AMI, and update the "KeyName" ParameterKey value to point to the keyname you wish to use to ssh into the EC2 instance. Also note, for CentOS images you tend to ssh in using "centos" user as opposed to "ec2-user" user.*

The above CloudFormation template and bash script map to the **"Master-less Puppet"** section of chapter 4 in the book.

### aws-cfn.sh
Setup CentOS 7 host with cfn-bootstrap python packages installed to support using of CloudFormation cfn-init, 
cfn-hup, etc helper scripts.

Credit to [cgswong](https://gist.github.com/cgswong/1ab591eaf813f987622dc2dab9a54648)

### ch04 TODO:
* Provide working Puppet client/master CloudFormation templates???

## ch05

For chapter 5 I will attempt to provide working AWS CloudFormation and puppet manifests/modules that map to the running example in chapter 5. My plan is to stick to the spirit of the examples in the book as close as possible. Puppet manifests/modules will be updated to use Puppet v4.x. I believe the intent of the authors was to use masterless Puppet for the examples. 'puppet install' will be used for installation of standard puppet modules that reside in PuppetForge and pull custom puppet modules using 'git clone'.

To help map content in this git repository to the book I'll name the directories to be the same as the numbered examples in the book. For example, the directory named **example_5-9** maps to the Puppet modules/AWS CloudFormation scripts for Example 5-9.

### example_5-9

Remember to use "ubuntu" user to ssh into EC2 instance.

### ch05 TODO:
* Provide working CloudFormation templates for chapter 5.

## Misc
```
curl http://169.254.169.254/latest/user-data
curl http://169.254.169.254/latest/meta-data
```

