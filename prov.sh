#!/bin/bash

yum install mutt wget -y

wget http://www.almhuette-raith.at/apache-log/access.log

echo "0 * * * * /vagrant/main.sh" >> /var/spool/cron/root


