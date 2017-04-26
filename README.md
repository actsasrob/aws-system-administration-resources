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

#### First method to test without using AWS/EC2:
1. Create an ubuntu 16.10 server/VM. Log into server.
2. Install puppet agent:

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

3. Clone the git project:
```
   cd 
   git clone https://github.com/actsasrob/aws-system-administration-resources.git
   cd aws-system-administration-resources/ch05/example_5-8/myblog
```

4. Install standard puppet modules from PuppetForge and custom puppet modules:

   Edit TARGET_PATH variable in install_files.sh script to point to desired puppet module path and then execute installfiles.sh.

    ./install_files.sh

   **NOTE:** The install_files.sh script will output the command to run in the next step.

5. Run 'puppet apply' command to converge server and install myblog application.

6. Navigate to application in browser: http://<IP address>

#### Second method to test, without using AWS EC2, but using Vagrant.
1. Install vagrant and add box for 'ubuntu/yakkety64'.
2. Install this git project:

```
git clone https://github.com/actsasrob/aws-system-administration-resources.git
cd aws-system-administration-resources
```

3. Launch the virtual machine using vagrant:

This will install the puppet agent, install all necessary standard puppet modules, install the custom myblog puppet module and manifest files, then run 'puppet apply' command to converge server.
```
vagrant up example_5_8
```

4. Navigate to application in browser: http://192.168.250.11



### example_5-9

Provide working CloudFormation template and CLI script to create AWS EC2 instance for application.
* myblog/cloudformation/myblog.json - CloudFormation template.
* myblog.sh - Bash script which invokes 'aws cloudformation' CLI to create EC2 instance using CloudFormation template. _**NOTE: Costs will be incurred for creating AWS resources!!!**_
* _Before running the above script you must set up your AWS credentials in ~/.aws/credentials or via environment variables. Edit myblog.sh and change the KeyName parameter to use an appropriatekey name for your AWS account. Edit myblog.sh and select an AMI in the selected region running Ubuntu 16.10._
* Consistent with the content in the book masterless puppet is not yet integrated to install the application.
* Don't forget to use the AWS CloudFormation console to terminate the stack.

**NOTE:** Remember to use "ubuntu" user to ssh into EC2 instance.


### example_5-10

The book shows how to update the local_settings.py file for the mezzanine project to point to an external AWS RDS database. No additional source code provided for this example.

### example_5-11

Update the myblog.json CloudFormation template to allow RDS database username and password to be passed as parameters to CloudFormation stack. These parameters are then used by CloudFormation to create an RDS MySQL database instance. The database name, username, and password are then set in the UserData properties and passed to the associated EC2 web tier instance to update the mezzanine database connection properties, via puppet, in /srv/myblog/myblog/local_settings.py to allow the mezzanine application to connect to the RDS instance.

This example is not functional as the associated puppet modules need to be updated to take advantage of the properties passed to the EC2 instance via UserData.

### example_5-12

Update the Puppet myblog class definition in modules/myblog/manifests/init.pp to accept database connection parameters when class is declared.

### example_5-13

Update the puppet/manifests/site.pp file to read EC2 UserData, as JSON, and parse the JSON data into Puppet's internal hash format.

Set myblog module variables to capture server role and various database connection parameters.

### example_5-14

Update the modules/myblog/manifests/create_project.pp manifest to use database connecton parameters, set in myblog class, to update mezzanine local_settings.py file to configure database connection parameters. The example in the book assumes the local_settings.py does not exist and then goes on to make use of the myblog/templates/local_settings.py.erb template file to create the local_settings.py file.

However, what I found in practice is that a default local_settings.py file is created at the time the mezzanine project is created. My initial thought was to copy the local_settings.py file from a newly created mezzanine project and use it to create the local_settings.py.erb template. However the local_settings.py file contains a randomly generated secret. It would run counter to security to check this secret into version control. I will leave the source code for example 5-14 as specified in the book but will create an alternate implementation in example_5-14a to populate the local_settings.py file with updated database connection parameters.

### example_5-15

Contents of Puppet local_settings.py.erb template used to create contents of mezzanine project local_settings.py file specifying external database connection properties.


### example_5-14a

Alternative approach to populate external database connection properties to mezzanine project local_settings.py file using puppet "file_line" resource.

The 'ALLOWED_HOSTS' property will now be set in local_settings.py instead of settings.py.

**NOTE:** There is no example 5-14a counterpart in the book.

### example5-15a

Working example of Puppet myblog module and CloudFormation template to create RDS MySQL database instance for mezzanine project and EC2 web-tier instance running Nginx proxy to mezzanine application. This example uses the example 5-14a implementation to populate the mezzanine local_settings.py file with database connection parameters.

**NOTE:** There is no example 5-15a counterpart in the book.

My initial plan for this example was to install the Puppet agent, standard Puppet modules, and custom myblog Puppet module at instance boot time. However the approach in the book is to pass the server role and RDS database connection parameters to the web-tier EC2 instance via EC2 UserData. I don't believe you can pass both role(s) and a shell script (to build out the server) via UserData. If UserData is used to pass role(s) then another mechanism is needed to install Puppet and needed Puppet modules.

I will take the approach to use packer to build a custom AMI which will install the latest Puppet agent, install standard Puppet modules, and then use git to clone the myblog Puppet module, then move the myblog manifest files into place. A custom /etc/rc.local script will be installed to run the 'puppet apply' command at server boot time to converge the server.

Steps to run this example:
1. Change directory to ch05/example5_15a/myblog/packer directory.
2. Edit packer_image.json and set the "source_ami" line to point to a valid Ubuntu 16.10 AMI in the desired region. Save and exit.
3. Execute the packer_build.sh script (the packer command must be in your path) to build a custom AMI with Puppet agent, PuppetForge module dependencies for myblog application, and myblog custom Puppet module baked in.
4. Note the name of the new AMI image in the last line of the packer build.
5. Change directory up one level.
6. Edit myblog.sh script and set the value of the "WebAMI" parameter key to point to the AMI ID returned in step 4. Set the value of the "KeyName" parameter key to point to a valid SSH key for your account.
7. Execute the myblog.sh script. This will invoke the AWS CloudFormation CLI to build the application stack. Once the myblog.sh script returns wait a few minutes (for 'puppet apply' command to complete to converge the server) then go to the AWS CloudFormation console, find the entry for "example-5-15a-stack" and then select the "Outputs" tab. In a browser navigate to the web instance DNS name found in the "Value" column. You should see the mezzanine application splash page.
_**NOTE: Costs will be incurred for creating AWS resources!!!**_
8. Use the CloudFormation console to terminate the stack.

### ch05 TODO:
* Provide working CloudFormation + masterless puppet example after example 5-9
  * Use example 15a for this. However, I found you cannot use CloudFormation UserData to pass both roles and a shell script. It is one or the other. Given that it will be difficult to install the puppet agent and all the needed standard and custom Puppet modules via a shell script. Try to use UserData to set server role and then use packer to build a custom AMI with puppet agent and puppet modules baked in. Possibly install an /etc/rc.local script (sudo systemctl enable rc-local.service) to run 'puppet apply' after server boots the first time.
  * Troubleshoot why mezzanine cannot connect to RDS database instance.
* Provide working CloudFormation templates for chapter 5.

## Misc
```
curl http://169.254.169.254/latest/user-data
curl http://169.254.169.254/latest/meta-data
```

