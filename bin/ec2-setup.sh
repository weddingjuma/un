#!/bin/bash

# Copyright Applied Industrial Logic Limited 2014. All rights Reserved
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later 
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 51 
# Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

#
# OpenUnderwriter EC2 instance setup script.
# 
# Steps: 
# 1) Create an EC2 instance (target AIM: ami-bff32ccc).
#
# 2) From the command line on your local machine:
#      scp ec2-setup.sh ec2-user@<instance IP/domain name>:.
#      ssh -t ec2-user@<instance IP/domain name> sudo -s . ./ec2-setup.sh <instance IP/domain name> <mysql root pw> <OU artifact URL>
#
set -x

HOSTNAME=$1
MYSQL_ROOT_PASSWORD=$2
OU_ARTIFACT_URL=$3

OU_INSTALL_DIR=/opt/openunderwriter

if [ -z "$HOSTNAME" -o -z "$MYSQL_ROOT_PASSWORD" -o -z "OU_ARTIFACT_URL" ]; then
	echo "usage: $(basename $0) <hostname> <mysql root password> <ou artifact url>"
	exit
fi

yum -y update 

# Install MySQL and configure
yum -y install mysql-server
sed -i '/\[mysqld\]/a lower_case_table_names = 1' /etc/my.cnf 
chkconfig mysqld on
service mysqld start
# Secure MySQL
mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User = 'root'"
mysql -u root -e "DROP USER ''@'localhost'"
mysql -u root -e "DROP USER ''@'$(hostname)'"
mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -e "DROP DATABASE test"
mysql -u root -e "FLUSH PRIVILEGES"

# Remove OpenJDK and install Oracle's JDK instead
rpm --erase --nodeps java-1.7.0-openjdk
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jdk-7u79-linux-x64.rpm
yum -y install jdk-7u79-linux-x64.rpm
for i in /usr/java/jdk1.7.0_*/bin/*; do sudo alternatives --set $(basename $i) $i; done

# Install and configure apache
yum install -y httpd24 
yum install -y mod24_proxy_html
chkconfig httpd on
groupadd www
usermod -a -G www ec2-user
chown -R root:www /var/www
chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} +
find /var/www -type f -exec sudo chmod 0664 {} +
tee /etc/httpd/conf.d/openunderwriter.conf >/dev/null <<END
<VirtualHost *:80>
    ServerAdmin dick.anderson@ail-ltd.com

    ServerName $HOSTNAME 
    ServerAlias $HOSTNAME 

    ProxyRequests Off

    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/

    ProxyHTMLURLMap http://localhost:8080/ http://$HOSTNAME/
</VirtualHost>
END
sed -i 's:^:#:' /etc/httpd/conf.d/welcome.conf
sed -i "s/#ServerName www.example.com:80/ServerName $HOSTNAME:80/" /etc/httpd/conf/httpd.conf
service httpd start

# Install OpenUnderwriter
groupadd openunderwriter
useradd -g openunderwriter --system openunderwriter
mkdir $OU_INSTALL_DIR

curl $OU_ARTIFACT_URL > /tmp/openunderwriter.zip
unzip -q /tmp/openunderwriter.zip -d $OU_INSTALL_DIR
rm /tmp/openunderwriter.zip
ln -s /opt/openunderwriter/* /opt/openunderwriter/openunderwriter-community
PORTAL_EXT=/opt/openunderwriter/openunderwriter-community/liferay-portal-6.2.0-ce-ga1/portal-ext.properties
BIRT_WAR=/opt/openunderwriter/openunderwriter-community/liferay-portal-6.2.0-ce-ga1/jboss-7.1.1/standalone/deployments/birt.war
sed -i 's/javascript.fast.load=false/javascript.fast.load=true/' $PORTAL_EXT
sed -i '$a last.modified.check=true' $PORTAL_EXT
sed -i '$a theme.css.fast.load=true' $PORTAL_EXT
sed -i '$a web.server.host='$HOSTNAME $PORTAL_EXT
sed -i '$a web.server.http.port=80' $PORTAL_EXT
jar -xf $BIRT_WAR WEB-INF/viewer.properties
sed -i 's@#base_url=http://127.0.0.1:8080@base_url=http://'$HOSTNAME'@' WEB-INF/viewer.properties
jar -uf $BIRT_WAR WEB-INF/viewer.properties
chown -R -L openunderwriter.openunderwriter /opt/openunderwriter/openunderwriter-community
su openunderwriter -c 'cd /opt/openunderwriter/openunderwriter-community/bin; printf "root\n'$MYSQL_ROOT_PASSWORD'\n" | ./run.sh -nostart'
tee /etc/init.d/openunderwriter >/dev/null <<END
### BEGIN INIT INFO
# Provides:          openunderwriter
# Required-Start:    \$mysqld \$network \$syslog
# Required-Stop:     \$mysqld \$network \$syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/Stop OpenUnderwriter 3
### END INIT INFO
#
LAUNCH_JBOSS_IN_BACKGROUND=1
JBOSS_BIN=/opt/openunderwriter/openunderwriter-community/liferay-portal-6.2.0-ce-ga1/jboss-7.1.1/bin

case "\$1" in
    start)
        echo "Starting OpenUnderwriter 3"
        sudo su openunderwriter -c 'cd '\$JBOSS_BIN'; ./standalone.sh >/dev/null &'
        while [ "\$(\$JBOSS_BIN/jboss-cli.sh -c --commands='cd deployment,cd ROOT.war, read-attribute status' 2>/dev/null)" != "OK" ]; do echo -n .; done
        printf "\nServer started.\n"
    ;;
    stop)
        echo "Stopping OpenUnderwriter 3"
        sudo su openunderwriter -c 'cd '\$JBOSS_BIN'; ./jboss-cli.sh --connect command=:shutdown'
    ;;
    *)
        echo "Usage: /etc/init.d/jboss {start|stop}"
        exit 1
    ;;
esac

exit 0
END
chmod 755 /etc/init.d/openunderwriter
chkconfig --add openunderwriter
sed -i '$a 127.0.0.1 '$(uname -n) /etc/hosts
service openunderwriter start
