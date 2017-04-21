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
packer_example directory contains a working example of using packer to build an AMI image with puppet 4.x packages pre-installed and with a site.pp manifest and nginx module definition to install nginx as the default node type. The base AMI Ubuntu 16.10 "yakkety yak" is used because there is a puppetlabs repo available that provides Puppet 4.x packages.

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

For chapter 5 I will attempt to provide working AWS CloudFormation and puppet manifests/modules that map to the running example in chapter 5. My plan is to stick to the spirit of the examples in the book as close as possible. Puppet manifests/modules will be updated to use Puppet v4.x. I believe the intent of the authors was to use masterless Puppet for the examples. 'puppet module install' will be used for installation of standard puppet modules that reside in PuppetForge and pull custom puppet modules using 'git clone'.

To help map content in this git repository to the book I'll name the directories to be the same as the numbered examples in the book. For example, the directory named **example_5-9** maps to the Puppet modules/AWS CloudFormation scripts for Example 5-9.

**NOTE:** The mezzanine project now resides in /srv/myblog/mblog. The settings.py and and local_settings.py files reside in /srv/myblog/myblog instead of /srv/myblog as indicated in the book. This was done to workaround permission problems creating the /srv/myblog directory as the 'mezzanine' user. Also the /usr/local/bin/mezzaine-project script fails if the project directory already exists. The /srv/blog directory is created and ownership set to the 'mezzanine' user. Later the mezzanine project is created in /srv/myblog/myblog.

### example_5-3

Add puppet/manifests/site.pp file to drive installation of myblog class. This manifest file should be used with AWS EC2 instances where the server role has been set using "user data".

Added extra puppet/manifests/site_notec2.pp file that can be used to test installation when not using AWS EC2.

### example_5-4

Add puppet/modules/myblog/manifests/init.pp manifest to initialize myblog module.

### example_5-5

Add puppet/modules/myblog/manifests/requirements.pp to handle application requirements.

### example_5-6

Add puppet/modules/myblog/manifests/create_project.pp manifest to create mezzaine project and database.

### example_5-7

Add puppet/modules/myblog/manifests/mynginx.pp manifest to install nginx and proxy to mezzanine application.

### example_5-8

Add puppet/modules/myblog/manifests/web.pp manifest to define myblog::web class.

At this point enough of the myblog module has been defined to allow the mezzanine project to be created using masterless puppet on an Ubuntu 16.10 "yakkety yak" server.

First method to test without using AWS/EC2:
1. Create an ubuntu 16.10 server/VM. Log into server.
2. Install puppet agent

```
wget https://apt.puppetlabs.com/puppetlabs-release-pc1-yakkety.deb
  sudo dpkg -i puppetlabs-release-pc1-yakkety.deb
  sudo apt-get update
  sudo apt-get -y install puppet-agent

  sudo grep secure_path /etc/sudoers \
  | sed -e 's#"$#:/opt/puppetlabs/bin"#' \
  | sudo tee /etc/sudoers.d/puppet-securepath

  echo ". /etc/profile.d/puppet-agent.sh" >> ~/.bashrc
```

3. Clone the git project
```
   cd 
   git clone https://github.com/actsasrob/aws-system-administration-resources.git
   cd aws-system-administration-resources/ch05/example_5-8
```

4. Install standard puppet modules from PuppetForge and custom puppet modules

   Edit TARGET_PATH variable in install_files script to point to desired puppet module path

    ./install_files.sh

   **NOTE:** The install_files.sh script will output the command to run in the next step.

5. Run 'puppet apply' command to converge server and install myblog application.

6. Navigate to application in browser: http://192.168.250.11

Second method to test using Vagrant
1. Install vagrant and add box for 'ubuntu/yakkety64'.
2. Install this git project:

```
git clone https://github.com/actsasrob/aws-system-administration-resources.git
cd aws-system-administration-resources
```

3. Launch the virtual machine using vgrant

This will install the puppet agent, install all necessary standard puppet modules, install the custom myblog puppet module and manifest files, then run 'puppet apply' command to converge server.
```vagrant up example_5_8
```

4. Navigate to application in browser: http://192.168.250.11



### example_5-9

Provide working CloudFormation template and CLI script to create AWS EC2 instance for application.
* myblog/cloudformation/myblog.json - CloudFormation template.
* myblog.sh - Bash script which invokes 'aws cloudformation' CLI to create EC2 instance using CloudFormation template. _**NOTE: Costs will be incurred for creating AWS resources!!!**_
* Consistent with the content in the book masterless puppet is not yet integrated to install the application.

**NOTE:** Remember to use "ubuntu" user to ssh into EC2 instance.

### ch05 TODO:
* Provide working CloudFormation + masterless puppet example after example 5-9
* Provide working CloudFormation templates for chapter 5.

## Misc
```
curl http://169.254.169.254/latest/user-data
curl http://169.254.169.254/latest/meta-data
```

