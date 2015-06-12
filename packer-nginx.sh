#!/bin/bash

exit 0

echo "packer: adding packages"
sudo yum update -y
#sudo apt-key update
#sudo apt-get update
#sudo apt-get remove apt-listchanges
sudo yum install -y git gcc-c++ GraphicsMagick

echo "packer: nginx"
sudo mkdir -p /var/log/nginx
#sudo chown $INSTANCE_USER /var/log/nginx
#sudo chmod -R 755 /var/log/nginx
sudo yum install -y nginx
sudo chown nginx /var/log/nginx
sudo chmod -R 755 /var/log/nginx

echo "packer: nvm"
curl https://raw.githubusercontent.com/creationix/nvm/$NVM_VERSION/install.sh | bash
. ~/.nvm/nvm.sh

echo "packer: nodejs"
nvm install $NODE_VERSION
nvm alias default $NODE_VERSION
npm update -g npm

echo '[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh' >> ~/.bashrc

echo "packer: tweaking tcp"
sudo sysctl -w net.ipv4.tcp_slow_start_after_idle=0
sudo sysctl -w net.ipv4.tcp_window_scaling=1

#echo "packer: ipv4 forwarding"
#cp /etc/sysctl.conf /tmp/
#echo "net.ipv4.ip_forward = 1" >> /tmp/sysctl.conf
#sudo cp /tmp/sysctl.conf /etc/
#sudo sysctl -p /etc/sysctl.conf

#echo "packer: forward port 80 to 8080"
#sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
#sudo iptables -A INPUT -p tcp -m tcp --sport 80 -j ACCEPT
#sudo iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
#sudo iptables-save > /tmp/iptables-store.conf
#sudo mv /tmp/iptables-store.conf /etc/iptables-store.conf

#echo "packer: remember port forwarding rule across reboots"
#echo "#!/bin/sh" > /tmp/iptables-ifupd
#echo "iptables-restore < /etc/iptables-store.conf" >> /tmp/iptables-ifupd
#chmod +x /tmp/iptables-ifupd
#sudo mv /tmp/iptables-ifupd /etc/network/if-up.d/iptables

echo "packer: precaching server dependencies"
#mkdir -p ~/app/precache
#cp -r /tmp/mailtube ~/app/mailtube
#cp ~/app/mailtube/package.json ~/app/precache
#npm install --prefix ~/app/precache --production

echo "packer: installing nginx at system startup"
#sudo update-rc.d nginx defaults
sudo chkconfig --add nginx
sudo chkconfig nginx on

echo "updating nginx config files"
#sudo mkdir -p /data/www/web-public
#aws s3 cp s3://www.walkdesigner.com/builds/web-public.15.zip /tmp/ --region eu-west-1
#sudo unzip /tmp/web-public.15.zip -d /data/www/web-public

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled

#sudo rm /etc/nginx/sites-enabled/default
sudo mv -f /tmp/nginx.conf /etc/nginx/
sudo mv -f /tmp/walkdesigner.com /etc/nginx/sites-available
sudo ln -s /etc/nginx/sites-available/walkdesigner.com /etc/nginx/sites-enabled/walkdesigner.com

echo "restarting nginx"
sudo service nginx restart
# reload
