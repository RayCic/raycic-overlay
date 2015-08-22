# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kodi-pvr-plugins

DESCRIPTION="Kodi's Windows Media Center client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.wmc"

[[ ${PV} == *9999 ]] || KEYWORDS="~amd64"
