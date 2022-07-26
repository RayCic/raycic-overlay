# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic tmpfiles

DESCRIPTION="Standalone Kodi systemd files"
HOMEPAGE="https://github.com/graysky2/kodi-standalone-service"
SRC_URI="https://github.com/graysky2/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"

KEYWORDS="~amd64"

DEPEND="acct-group/kodi
        acct-user/kodi
"

src_compile() {
        true
}


pkg_postinst() {
        tmpfiles_process kodi-standalone.conf
}
