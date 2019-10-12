#!/bin/sh
# Copyright 2019 Gentoo Authors

brcmhbacmd="/opt/broadcom/brcmocmanager/bin/brcmhbacmd"

macs=`${brcmhbacmd} listhba | grep 'Current MAC' | grep -oE '([[:xdigit:]]{2}-){5}[[:xdigit:]]{2}'`

for mac in ${macs} ; do
	${brcmhbacmd} SetPortEnabled ${mac} 0
done

sleep 3s

for mac in ${macs} ; do
	${brcmhbacmd} SetPortEnabled ${mac} 1
done
