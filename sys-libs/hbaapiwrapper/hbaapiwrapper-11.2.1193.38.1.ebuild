# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit emulex

DESCRIPTION="OCManager libbrcmdfc and libbrcmhbaapi libraries"

RDEPEND="dev-libs/libnl:1.1"

S="${WORKDIR}"

src_install() {
	into "${EMULEX_INTO}"
	dolib.so usr/lib64/*

	dodir /etc/ld.so.conf.d/
	echo "${EMULEX_INTO}/$(get_libdir)" > ${ED}/etc/ld.so.conf.d/50${PN}.conf || die
}
