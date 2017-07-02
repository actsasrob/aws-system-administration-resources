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

### example_5-1

Add runnable example, using vagrant, to create mezzanine application fronted by Nginx.

The setup_mezzanine.sh script contains the steps to install and configure a mezzanine Django application. Vagrant is used to launch an Ubuntu 16.10 VM using VirtualBox. The vagrant VM clones this GIT project and then invokes the ch05/example_5-1/setup_mezzanine.sh script to install/configure and run the Django application.

To run the example:
1. Install vagrant/VirtualBox
2. Install the Ubuntu 16.10 vagrant image:
```
vagrant box add "ubuntu/xenial64"
```

3. cd to the top-level directory for this git project. Same directory at the 'Vagrantfile' file.
4. Launch the example_5_1 VM using vagrant:
```
vagrant up example_5_1
```

You can ssh to the VM using:
```
vagrant ssh example_5_1
```

**NOTE:** Type 'exit' followed by the enter key to exit the ssh session.

To destroy the VM use:
```
vagrant destroy example_5_1
```

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

   Edit TARGET_PATH variable in install_files.sh script to point to desired puppet module path and then execute install_files.sh.

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

### example_5-16

Consistent with the content in the book this example add cache cluster support for the Mezzanine application.

The puppet local_settings.py.erb template is updated to add the "CACHES" block to make the Mezzanine application aware of the cache cluster endpoint. The template expects a variable named "cache_endpoint" will exist and contain a reference to an existing cache cluster endpoint.

The puppet myblog requirements.pp manifest is updated to ensure the python-memcached package is installed via python pip.

The puppet site.pp manifest is updated to retrieve the cache cluster endpoint via CloudFormation UserData. The endpoint is then passed as a parameter, named cache_endpoint, to the myblog class declaration to initialize the puppet myblog class. When the myblog class is instantiated the puppet myblog local_settings.py.erb template will be invoked to create the Mezzanine local_settings.py file containing a reference to the cache cluster endpoint.

Finally, the CloudFormation template is updated to add a Memcached resource named "CacheCluster" which will cause an AWS Memcached cluster to be created when the CloudFormation template is invoked. In example_5-17 the CloudFormation template UserData section will be updated to pass a reference to the Memcached cluster endpoint, via JSON key cache_endpoint, to the web server EC2 instance at launch time.

**NOTE:** This example is not runnable.

### example_5-17

The CloudFormation template UserData section is updated to pass a reference to the AWS Elaticache Memcached cluster endpoint, via JSON key cache_endpoint, to the web server EC2 instance at launch time.

**NOTE:** This example is not runnable.

### example_5-18

Add /srv/myblog/tasks.py containing celery task to perform spam check for each new blog post.

**NOTE:** This example is not runnable.

### example_5-19

Update the /srv/myblog/myblog/local_settings.py file to initialize the django-celery package.

**NOTE:** This example is not runnable.

### exmaple_5-20

Various puppet module updates to install and start django-celery.

myblog/puppet/manifests/site.pp is updated to recognize a server "celery" role, passed via CloudFormation UserData, and the $role_class variable is set appropriately so that the myblog::celery class will be declared when the server role is set to "celery".

The myblog::celery class manifest is created in myblog/puppet/modules/myblog/manifests/celery.ppp.

Configuration logic is added to the myblog/puppet/modules/myblog/templates/local_settings.py.erb to configure the django celery module.

Update CloudFormation template to create IAM role/policy allowing web/celery EC2 instances to interact with SQS queue, update Resources section to create an EC2 instance running Django celery task, allow web,celery EC2 instances access to Cache cluster, and update RDS DB ingress rules to permit access by web/celery EC2 instances.

### example_5-21


Example 5-21 uses AWS CloudFormation, puppet, and packer  to provision a Django/Mezzanine-based blogging platform. EC2 web instances serve up the Mezzanine web application providing admins the ability to blog. Users can comment on blogs. When comments are saved a Django "post_save" signal fires. A signal handler residing in the "celerytasks" app within the Mezzanine project acts as a receiver for the signal. The signal handler, "process_comment()", invokes the "process_comment_async()" Celery task to asynchronously process the comment to determine if the comment contains spam. Celery uses AWS SQS as the message queue transport. Celery worker tasks reside on the EC2 Celery instance. Celery works poll a configured SQS queue for work. Celery handles serializing the "process_comment_async() function to SQS. The Celery worker invokes the function and is passed a reference to the actual comment to process. The Celery worker, in this case, performs a simple check to determine if the comment contanins spam, and if so, uses the Mezzanine ThreadedComment model to retrieve the actual comment object from the Mezzanine DB and updates its status to be non-pubic which effectively renders the comment not visibile to application  users.

The example works with the following caveats:

**CAVEAT 1:** I believe the intention of the example in the book was to use packer to fully provision a web AMI with a functional Mezzanine web app and a celery AMI with a functional Celery tasks module and worker. However, in the book only the role(web or celery) is passed to the temporary EC2 instance. When the 'puppet apply' command is executed it fails to fully provision the respective EC2 instance because, among other things, database credentials are needed to fully provision the application. Since DB credentials are not available at the time packer runs puppet cannot successfully build out the web/celery instances. I changed the behavior to install the puppet modules and dependent puppet modules at packer build time. In addition an /etc/rc.local service init script is installed which will run 'puppet apply' when and EC2 instance boots up. Since AWS CloudFormation will pass the needed roles and metadata, e.g. DB credentials, the 'puppet apply' command can build out the server the first time it boots up (at the expense of a longer boot time the first time the EC2 instance is booted). The web/celery roles eare no longer passed to the temporary EC2 instance when packer runs. As such two separate AMIs (one for web and one for Celery) are no longer needed. The packer build script now only builds a single AMI.

**CAVEAT 2:** I believe the intent of the book was to create an EC2 instance profile, as opposed to using username/password or access key/secret access key,  that allows the web and celery EC2 instances sufficient run-time permissions to interfact with the SQS queue created via CloudFormation. However it appears Celery does not recognize the available EC2 instance profile. It seems to require credentials to be passed via message broker transport options. To make the example work I created a temporary user using IAM and granted it the "AmazonSQSFullAccess" policy. The access key/secret access key for this user were downloaded. The CloudFormation launch script was modified to allow the access key/secret access key to be passed to the web/celery instances via EC2 user-data. The Celery producer and consumer instances use these credentials to interact with SQS.

**CAVEAT 3:** I found I could use the Django/Mezzanine local_settings.py to configure the name of the SQS queue used by the Celery consumer(i.e. 'the Celery worker instances'). However the Celery producer does not to pick up these settings and always uses the default Celery queue named 'celery'. To make the example work the Celery consumer is configured, via local_settings.py, to use the default queue name.


Steps to run this example:

1. Clone the git project:
```
   git clone https://github.com/actsasrob/aws-system-administration-resources.git
   cd aws-system-administration-resources/ch05/example_5-21/myblog/packer
```

2. Build the AWS AMI containing the myblog puppet module and dependent puppet modules:

   Edit the packer_image.json file. Change the "source_ami" setting to point to an Ubuntu 16.10 AMI as your base AMI. 
   e.g. in the us-east-1 region I use: "ubuntu/images-testing/hvm-ssd/ubuntu-yakkety-daily-amd64-server-20170303.1 - ami-0f6fb419"

   Save and exit.

   You will need packer installed for the next step.

   Execute the 'myblog.sh' script to invoke packer to build the base web/celery AMI using the packer_image.json configuration file. Wait until this completes and then copy the AMI ID output at the end of the script. 

   **NOTE:** If you modify the myblog puppet modules you will need to re-run the packer script to rebuild the base AMI images. In this case you should fork the https://github.com/actsasrob/aws-system-administration-resources.git project. In your forked version of the git project modify .../example_21/myblog/packer/install_puppet.sh to clone your forked project. If you modify the puppet modules you must check changes into your git project as the install_puppet.sh script always clones the latest git project during the packer build.

   Next cd up one directory to the example_5-21/myblog directory.

3. Create a tempory SQS user via IAM. e.g. 'tmp_sqs_user'. Grant this user the 'AmazonSQSFullAccess' role. This user will need sufficient permissions to create/read/write/delete SQS queues for your AWS account. Down the access key and secret access keys for this user.

4. Run the example_21/myblog/myblog_sh script to kick off the CloudFormation build process to provision the AWS cluster.

   The example_21/myblog.sh invokes 'aws cloudformation' CLI to create EC2 instances using the CloudFormation template. 
   _**NOTE: Costs will be incurred for creating AWS resources!!!**_

   Before running the above script you must set up your AWS credentials in ~/.aws/credentials or via environment variables.

   First edit example_21/myblog.sh as follows:

```
      Replace the "<change_ami>" text with the AMI ID from step 2 above.
      Replace the "<secret_key>" and "<secret_access_key>" text with the secret key and secret access key from step 3 above.
      Replace the "<change_key>" text with an SSH key for your AWS account. This key will allow ssh access to the web/Celery EC2 instances created by CloudFormation.
```

   **NOTE:** The CloudFormation script is hardcoded to the us-east-1 AWS region. Modify the "--region" parameter in myblog.sh and the example_5-21/myblog/cloudformation/myblog.json CloudFormation template file to launch resources in a different regions if desired.


   Now execute example_5-21/myblog.sh to launch the CloudFormation script. The script will hang until all AWS resources have been created.

4. Create blog entries using Mezzanine app:

You must be an admin user to create blog entries. Use the steps below to create an admin user:

How to create admin account for mezzanine:
```
ssh into EC2 web instance
sudo su -
cd /srv/myblog
python manage.py createsuperuser
```

You can find the URL for the Mezzanine web app in the CloudFormation Web Console in the 'Outputs' tab under key 'WebInstanceDNSName'.
Navigate to the value for this key in a browser. Log in as the admin user created above.

You should be able to create blog post as the admin user.

Use the admin interface to create a non-admin user that has "Staff Access" level accesses. Use the user with staff accesses to create comments for blog entries. **NOTE:** only comment entries are checked for spam. For this example comments containing the word 'spam' anywhere in the comment content are considered spam. Create a number of comments with and without the word 'spam' in the content. Now log out and and log back in with the admin user. Navigate to the "Comments" dashboard. Any comment containing the word 'spam' should have a non-public status which means it is not visible to non-admin users.


Example 5-21 works with the following pip package versions:
```
pip list
amqp (1.4.9)
boto (2.47.0)
celery (3.1.25)
Django (1.10.7)
django-celery (3.2.1)
django-contrib-comments (1.8.0)
kombu (3.0.37)
Mezzanine (4.2.3)
```
### ch05 TODO:
  * Troubleshoot why Celery producer defaults to using queue named "celery" vs the queue configured in local_settings.py
