# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kodi-pvr-plugins

DESCRIPTION="Kodi's DVBViewer client addon"
HOMEPAGE="https://github.com/kodi-pvr/pvr.dvbviewer"

DEPEND="dev-libs/tinyxml"

RDEPEND="${DEPEND}"