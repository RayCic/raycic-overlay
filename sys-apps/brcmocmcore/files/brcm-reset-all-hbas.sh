#!/bin/sh
# Copyright 2019 Gentoo Authors

brcmhbacmd="/opt/broadcom/brcmocmanager/bin/brcmhbacmd"

if [ -f /etc/broadcom/macs.conf ] ; then
	echo "MACs file found. Reading MACs."
	macs=`cat /etc/broadcom/macs.conf`
else
	echo "MACs file NOT found. Detecting MACs."
	macs=`${brcmhbacmd} listhba | grep 'Current MAC' | grep -oE '([[:xdigit:]]{2}-){5}[[:xdigit:]]{2}'`
fi

for mac in ${macs} ; do
	${brcmhbacmd} SetPortEnabled ${mac} 0
done

sleep 3s

for mac in ${macs} ; do
	${brcmhbacmd} SetPortEnabled ${mac} 1
done
