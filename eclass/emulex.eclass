# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: emulex.eclass
# @MAINTAINER:
# Raimonds Cicans <ray@apollo.lv>
# @AUTHOR:
# Raimonds Cicans <ray@apollo.lv>
# @BLURB: Helper eclass for Emulex (now part of Broadcom) NIC tools

case ${EAPI:-0} in
	7) ;;
	*) die "Unsupported EAPI=${EAPI} for ${ECLASS}";;
esac

IUSE="+rhe sles"
REQUIRED_USE="^^ ( rhe sles )"
KEYWORDS="-* ~amd64" # Closed source. x86 version is too outdated.

# All packages are closed source and proprietary
LICENSE="all-rights-reserved"
RESTRICT="bindist fetch installsources mirror strip test"
HOMEPAGE="https://www.broadcom.com/support/download-search?pg=Legacy+Products&pf=Legacy+Ethernet+Network+Adapters&pa=Management+Software+and+Tools"
SLOT="0/${PV}"

DEPEND="app-arch/rpm"

MY_PV=$(ver_rs 4 '-')
SRC_URI="
	rhe? ( brcmocm-rhel6-rhel7-${MY_PV}.tgz )
	sles? ( brcmocm-sles11-sles12-${MY_PV}.tgz )
"

EMULEX_INTO="/opt/broadcom/brcmocmanager"

emulex_src_unpack() {
	if use rhe ; then
		local myfile="brcmocm-rhel6-rhel7-${MY_PV}/x86_64/rhel-7/${PN}-${MY_PV}.x86_64.rpm"
	else if use sles ; then
			local myfile="brcmocm-sles11-sles12-${MY_PV}/x86_64/sles-12-sp2/${PN}-${MY_PV}.x86_64.rpm"
		else
			die "Nor 'rhe' nor 'sles' USE flag privided"
		fi
	fi

	# WARNING!!! Some RPM packages are buggy.
	# Only rpm2archive is clever enough to deal with all of them.
	tar --extract --auto-compress --to-stdout --file="${DISTDIR}/${A}" "${myfile}" | rpm2archive | tar --extract --ungzip --file=-
}

EXPORT_FUNCTIONS src_unpack
