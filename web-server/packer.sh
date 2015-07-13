#!/bin/bash

echo "packer: adding packages"

sudo yum update -y
sudo yum install -y gcc-c++ make
sudo yum install -y openssl-devel
sudo yum install -y GraphicsMagick
sudo yum install -y git

echo "packer: cloning and building node"

git clone git://github.com/joyent/node.git
cd node
git checkout $NODE_VERSION
./configure
make
sudo make install
cd ~

echo "packer: creating global dir links for node"

sudo ln -s /usr/local/bin/node /usr/bin/node
sudo ln -s /usr/local/lib/node /usr/lib/node
sudo ln -s /usr/local/bin/npm /usr/bin/npm
sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

echo "packer: installing nginx"

sudo mkdir -p /var/log/nginx
sudo yum install -y nginx
sudo chown nginx /var/log/nginx
#sudo chown $INSTANCE_USER /var/log/nginx
sudo chmod -R 755 /var/log/nginx

echo "packer: tweaking tcp"

sudo sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sudo sysctl -w net.ipv4.tcp_window_scaling=1

echo "packer: preparing node on startup"

cp /home/ec2-user/web-api-initd /etc/init.d/
chmod +x /etc/init.d/web-api-initd

echo "packer: basic nginx config"

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
sudo mv -f /home/ec2-user/nginx.conf /etc/nginx/
