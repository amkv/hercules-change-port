#!/bin/sh

OLD="Port 22"
NEW="Port 51234"
LINK=/etc/ssh/
APT_LINK=/etc/apt/
APT_NAME=sources.list
SSHD_CONF=sshd_config
BACKUP=sshd_config_backup

#do you have rights?
#WARNING: you shoud be a root user or have rights to changing system files
WHO=$(whoami)
if [ "$WHO" = "root" ]; then
	echo "0. OK, you are $WHO and have a rights to make changes."
else	
	echo "You shoud have access rights to make changes, so login as root or use su"
	echo "Input root pussword and manualy launch script again"
 	su
fi

#is sshd config exist?
if [ -f $LINK$SSHD_CONF ]; then
	echo "0. $SSHD_CONF exist"
else
	echo "$LINK$SSHD_CONF does not exist"
	sed -i -e "s/deb cdrom/# deb cdrom/g" $APT_LINK$APT_NAME
	apt-get -y install ssh
fi

#change firewall rules (is firewall enabled?) (disabled by default)

#make backup file BACKUP
cp ${LINK}${SSHD_CONF} ${LINK}${BACKUP}
echo "1. original file $SSHD_CONF saved: $LINK$BACKUP"

#using SED find OLD and change it to NEW
sed -i -e "s/${OLD}/${NEW}/g" ${LINK}${SSHD_CONF}
echo "2. you successfully changed SSH $OLD to $NEW"

#restart sshd deamon
echo "3. restarting sshd daemon"
service sshd restart
echo "4. done. sshd daemon status:"
service sshd status

#return to back
sed -i -e "s/# deb cdrom/deb cdrom/g" $APT_LINK$APT_NAME
