#!/bin/bash

mkdir -p /modules/logs/

exec > /modules/logs/activemq.startup.${EYP_INSTANCE_NUMBER}.log 2>&1

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
	if [ "$(ps -fea | grep [a]ctivemq | wc -l)" -ne 1 ];
	then
		/etc/init.d/activemq start
	fi
	sleep 10
done
