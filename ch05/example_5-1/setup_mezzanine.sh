#!/bin/bash

set -x

MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`
echo "\$MY_PATH=$MY_PATH"

sudo apt -y install python-pip python-dev
sudo apt -y istall libjpeg8 libjpeg8-dev libtiff5-dev zlib1g-dev libfreetype6-dev python-imaging

sudo pip install Mezzanine
sudo useradd mezzanine
sudo mkdir -p /srv/myblog
sudo chown mezzanine /srv/myblog

sudo -u mezzanine mezzanine-project myblog /srv/myblog
cd /srv/myblog

#sudo -u mezzanine python manage.py createdb
#sudo -u mezzanine python manage.py runserver 0.0.0.0:8000

# Install/config Nginx
sudo apt -y install nginx
sudo mv /etc/nginx/sites-enabled/default ~/default.orig

sudo cp $MY_PATH/myblog.conf /etc/nginx/sites-enabled/myblog.conf
sudo chmod 644 /etc/nginx/sites-enabled/myblog.conf

#sudo systemctl enable nginx
#sudo systemctl start nginx

