# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit emulex systemd

DESCRIPTION="OCManager Command Line Interface"

RDEPEND="sys-libs/brcmocmcorelibs:0/${PV}[rhe=,sles=]
	sys-apps/hbaapi
"

S="${WORKDIR}"

src_install() {
	into "${EMULEX_INTO}"
	dolib.so usr/lib64/*

	exeinto "${EMULEX_INTO}/bin"
	doexe usr/sbin/brcmocmanager/brcmhbacmd
	dosym "${EMULEX_INTO}/bin/brcmhbacmd" /opt/bin/brcmhbacmd

	exeinto "${EMULEX_INTO}/sbin"
	doexe usr/sbin/brcmocmanager/brcmhbamgrd
	doexe "${FILESDIR}/brcm-reset-all-hbas.sh"

	insinto "/etc"
	doins -r etc/broadcom
	doins "${FILESDIR}/brcmRMConfig"
	doins "${FILESDIR}/brcmRMOptions"
	doins "${FILESDIR}/brcmDiscConfig"

	doinitd "${FILESDIR}/brcmhbamgrd"
	doinitd "${FILESDIR}/brcm-reset-all-hbas"

	systemd_dounit "${FILESDIR}"/*.service

	### TODO: move to init script
	keepdir "/var/cache/broadcom/brcmocmanager/RMRepository"

	keepdir "/var/log/broadcom/brcmocmanager/Dump"
	keepdir "/var/log/broadcom/brcmocmanager/logs"
	keepdir "/var/log/broadcom/mili/logs"

	# Fix paths hatdcoded in software
	##dosym /var/log/broadcom /var/opt/broadcom
	dosym ../log/broadcom /var/opt/broadcom

	# Fake file to make software happy
	dosym /bin/false /usr/sbin/brcmocmanager/convert_conf_file
}

pkg_config() {
	elog "Updating /etc/hba.conf"
	if [[ -f /etc/hba.conf ]] ; then
		if grep -Eq "^com.brcmcna.brcmapilibrary64[[:space:]]" "${ROOT%/}/etc/hba.conf" 2>/dev/null ; then
			ewarn "/etc/hba.conf - already configured. Skipping."
		else
			cat <<-EOF >> "${ROOT%/}/etc/hba.conf" || die
				com.brcmcna.brcmapilibrary64 /opt/broadcom/brcmocmanager/lib64/libbrcmhbaapi.so
			EOF
			elog "/etc/hba.conf - updated"
		fi
	else
		eerror "/etc/hba.conf - do not exist"
	fi
}
