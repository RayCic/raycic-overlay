# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 cmake-utils

DESCRIPTION="Kodi platform support library"
HOMEPAGE="https://github.com/xbmc/kodi-platform"

EGIT_REPO_URI="https://github.com/xbmc/kodi-platform.git"

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="media-tv/kodi"

DEPEND="${RDEPEND}
	dev-libs/libplatform"
