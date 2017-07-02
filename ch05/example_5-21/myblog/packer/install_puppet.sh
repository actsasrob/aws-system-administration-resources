wget --quiet http://apt.puppet.com/puppetlabs-release-pc1-yakkety.deb
sudo dpkg -i puppetlabs-release-pc1-yakkety.deb

# Upgrade available packages
# Workaround issue: https://bugs.launchpad.net/ubuntu/+source/apt/+bug/1323772
sudo apt-get update
sudo rm /boot/grub/menu.lst
sudo update-grub-legacy-ec2 -y
sudo apt-get dist-upgrade -qq --force-yes

# Should not be installed, but just in case we caught you using an old instance...
sudo apt-get remove -y puppet-agent
# Install latest version of puppet from PuppetLabs repo
sudo apt-get install -y puppet-agent
rm puppetlabs-release-pc1-yakkety.deb


sudo grep secure_path /etc/sudoers \
 | sed -e 's#"$#:/opt/puppetlabs/bin"#' \
 | sudo tee /etc/sudoers.d/puppet-securepath

echo "Check out aws-system-administration-resources git project..."
cd
git clone https://github.com/actsasrob/aws-system-administration-resources.git

cd aws-system-administration-resources/ch05/example_5-21/myblog
./install_files.sh
cd 
rm -rf aws-system-administration-resources

echo "Installing /etc/rc.local script to run at boot time and execute 'puppet apply' command..."
cat << 'EOF' | sudo tee /etc/rc.local
#!/bin/bash

start_rclocal() {
   while fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
      echo "Waiting for dpkg lock to be released..." > /var/log/rc.local.log 2>&1
      sleep 5 
   done 

   rm -rf /opt/puppetlabs/puppet/cache/ 
   /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp > /var/log/rc.local.log 2>&1
   sleep 5
   /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp > /var/log/rc.local.log 2>&1
   sleep 5
   /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp > /var/log/rc.local.log 2>&1
   return $?
}

case "$1" in
        start)
                start_rclocal
                ;;
        *)      ;;
esac
EOF

# /etc/rc.local must be executable to run at boot
sudo chmod 700 /etc/rc.local
