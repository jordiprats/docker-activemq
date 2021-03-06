#!/bin/bash

mkdir -p /logs/logs/

exec > /logs/logs/activemq.startup.${EYP_INSTANCE_NUMBER}.log 2>&1

apt-get update

cat <<EOF > /tmp/manifest.pp
class { 'mcollective::activemq':
 adminpw => 'admin',
 userpw => '${EYP_ACTIVEMQ_ADMIN_PASSWORD-Y2F0YWx1bnlhbGxpdXJlCg}',
}
EOF

touch /etc/puppet/hiera.yaml
sed '/^templatedir/d' -i /etc/puppet/puppet.conf

puppet apply --modulepath=/usr/local/src/puppetmodules/ /tmp/manifest.pp

/etc/init.d/activemq start

sleep 5

while true;
do
	if [ "$(ps -fea | grep [a]ctivemq | wc -l)" -eq 0 ];
	then
		/etc/init.d/activemq start
	fi
	sleep 10
done
