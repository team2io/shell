#!/bin/sh
# backupConf.sh

echo "###ST Time : `date '+%Y-%m-%d'` `date '+%H:%M:%S'`"
echo ""

rm -rf /homedata/*

#common
mkdir -p /homedata/web
mkdir -p /homedata/db
mkdir -p /homedata/conf/bin

history > /homedata/conf/history.txt
crontab -l > /homedata/conf/crontab.txt
netstat -nltp > /homedata/conf/netstat.txt
pstree > /homedata/conf/pstree.txt
grep . /etc/*-release > /homedata/conf/os.txt

/bin/cp -arp /root/ /homedata/conf
/bin/cp -arp /etc/resolv.conf /homedata/conf
/bin/cp -arplf /etc/rc.d/rc.local /homedata/conf
/bin/cp -arp /etc/sysconfig/iptables /homedata/conf
/bin/cp -arp /usr/local/bin/* /homedata/conf/bin

if [ `pgrep -f httpd | wc -l` -gt 0 -a -d "/opt/apache2/conf" ]; then
	echo "#opt apache2"
	mkdir -p /homedata/conf/apache2
	/bin/cp -arp /opt/apache2/conf /homedata/conf/apache2/
fi

if [ `pgrep -f httpd | wc -l` -gt 0 -a -d "/etc/httpd/conf" ]; then
	echo "#etc httpd"
	mkdir -p /homedata/conf/http
	/bin/cp -arp /etc/httpd/conf /homedata/conf/http/
	/bin/cp -arp /etc/httpd/conf.d /homedata/conf/http/
fi

if [ `pgrep -f nginx | wc -l` -gt 0 -a -d "/opt/nginx/conf" ]; then
	echo "#opt nginx"
	/bin/cp -arp /opt/nginx/conf/* /homedata/conf/nginx
fi

if [ -f "/etc/my.cnf" ]; then
	echo "#etc mysql"
	/bin/cp -arp /etc/my.cnf /homedata/conf
fi

if [ -f "/etc/php.ini" ]; then
	echo "#etc php"
	/bin/cp -arp /etc/php.ini /homedata/conf
fi

if [ `pgrep -f etrecvd | wc -l` -gt 0 -a -d "/opt/mediahold" ]; then
	echo "#opt mediahold"
	/bin/cp -arp /opt/mediahold /homedata/conf/
fi

if [ `pgrep -f vsftpd | wc -l` -gt 0 -a -d "/opt/vsftpd" ]; then
	echo "#opt vsftpd"
	/bin/cp -arp /opt/vsftpd /homedata/conf/
fi

if [ `pgrep -f vsftpd | wc -l` -gt 0 -a -d "/etc/vsftpd" ]; then
	echo "#etc vsftpd"
	/bin/cp -arp /etc/vsftpd /homedata/conf/
fi

#ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'
_IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p' | head -n 1`
_NOWDATE=`date +%Y%m%d%H`
_FILENAME="BACKUP_CONF_${_IP}_${_NOWDATE}.tar.gz"
echo echo "#tar " ${_FILENAME}
tar -zcf ~/${_FILENAME} /homedata
rm -rf /homedata/*
mv ~/${_FILENAME} /homedata


echo ""
echo "###EN Time : `date '+%Y-%m-%d'` `date '+%H:%M:%S'`"
