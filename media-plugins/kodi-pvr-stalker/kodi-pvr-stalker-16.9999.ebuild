# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kodi-pvr-plugins

DESCRIPTION="A PVR Client that connects Kodi to Stalker Middleware"
HOMEPAGE="https://github.com/kodi-pvr/pvr.stalker"

DEPEND="dev-libs/tinyxml
	dev-libs/jsoncpp"

RDEPEND="${DEPEND}"
