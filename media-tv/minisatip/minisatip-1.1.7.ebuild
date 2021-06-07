# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="minisatip, a SAT>IP server using local DVB-S2, DVB-C, DVB-T or ATSC cards"
HOMEPAGE="https://minisatip.org/"
#SRC_URI="https://github.com/catalinii/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/catalinii/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="dvbca dvbaes dvbcsa satipc static dvbapi"

DEPEND="
	!static? (
		media-tv/linuxtv-dvb-apps
		dvbaes? ( dev-libs/openssl )
		dvbcsa? ( media-libs/libdvbcsa )
	)
	static? (
		media-tv/linuxtv-dvb-apps
		dvbaes? ( dev-libs/openssl[static-libs] )
		dvbcsa? ( media-libs/libdvbcsa[static-libs] )
	)"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--prefix=/usr/bin
		--enable-linuxdvb
		--disable-axe
		--disable-enigma
		--disable-netcv
		$(use_enable dvbca )
		$(use_enable dvbaes )
		$(use_enable dvbcsa )
		$(use_enable satipc )
		$(use_enable dvbapi )
		$(use_enable static )
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	dobin minisatip

	newinitd "${FILESDIR}"/minisatip.init minisatip
	newconfd "${FILESDIR}"/minisatip.conf minisatip

	local HTML_DOCS="html/*"

	einstalldocs
}
