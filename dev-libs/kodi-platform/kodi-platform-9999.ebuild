# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Kodi platform support library"
HOMEPAGE="https://github.com/xbmc/kodi-platform"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/xbmc/kodi-platform.git"
	inherit git-r3
else
	SRC_URI="https://github.com/xbmc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="dev-libs/libplatform"
RDEPEND=""
