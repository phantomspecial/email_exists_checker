#!/bin/sh

echo ------------------------------
echo START!
echo ------------------------------

echo ------------------------------
echo Timezone
echo ------------------------------
date
sudo timedatectl set-timezone Asia/Tokyo
date
echo Timezone_changed.


echo ------------------------------
echo Preparing installation
echo ------------------------------
sudo yum -y install httpd
sudo systemctl restart httpd.service
sudo yum -y install unzip wget perl-ExtUtils-MakeMaker readline-devel gcc-c++ libxml2-devel libxslt-devel sqlite-devel


echo ------------------------------
echo Git install
echo ------------------------------
sudo yum remove git
sudo yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
cd /usr/local/src/
sudo wget https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
sudo tar xzvf git-2.9.5.tar.gz
cd git-2.9.5/
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install


echo ------------------------------
echo Ruby install
echo ------------------------------
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
rbenv rehash

rb_version=`cat /vagrant/.ruby-version`
echo $rb_version
rbenv install -v $rb_version
rbenv global $rb_version
rbenv rehash


echo ------------------------------
echo nodejs install
echo ------------------------------
sudo yum -y install epel-release
sudo yum -y install nodejs npm
sudo npm install -g n
sudo n stable


echo ------------------------------
echo MySQL install
echo ------------------------------
sudo yum -y localinstall http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
sudo yum-config-manager --disable mysql-connectors-community
sudo yum-config-manager --disable mysql-tools-community
sudo yum -y install mysql mysql-devel mysql-server mysql-utilities
sudo systemctl start mysqld.service
sudo systemctl enable mysqld.service


echo ------------------------------
echo MySQL setting
echo ------------------------------
password=`sudo cat /var/log/mysqld.log | grep "A temporary password" | tr ' ' '\n' | tail -n1`
mysql -u root -p${password} --connect-expired-password < /vagrant/provisioner.sql
sudo sh -c "echo 'bind-address=0.0.0.0' >> /etc/my.cnf"

echo ------------------------------
echo Rails install
echo ------------------------------
gem update --system
gem install rails -N


gem install bundler --no-document --force
bundle config build.nokogiri --use-system-libraries
cd && cd /vagrant
bundle install --path vendor/bundle -j 4


echo ------------------------------
echo DB setting
echo ------------------------------
cd && cd /vagrant
bundle exec rake db:create
bundle exec rake db:migrate


echo ------------------------------
echo alias/other setting
echo ------------------------------
echo 'TERM="vt100"' >> ~/.bashrc
echo 'alias vrs="cd /vagrant && bundle exec rails s -b=0.0.0.0"' >> ~/.bashrc
echo 'alias vag="cd /vagrant"' >> ~/.bashrc
echo 'alias rs="bundle exec rails s -b=0.0.0.0"' >> ~/.bashrc
echo 'alias routes="bundle exec rake routes"' >> ~/.bashrc
echo 'alias bi="bundle install"' >> ~/.bashrc
echo 'EDITOR="vi"' >> ~/.bashrc
source ~/.bashrc
