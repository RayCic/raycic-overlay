# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kodi-pvr-plugins

DESCRIPTION="Kodi PVR addon VNSI"
HOMEPAGE="https://github.com/kodi-pvr/pvr.vdr.vnsi"

IUSE="+opengl gles"

REQUIRED_USE="opengl? ( !gles )"

DEPEND="media-tv/kodi[opengl?,gles?]
	opengl? ( virtual/opengl )
	gles? ( media-libs/mesa[gles2] )"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		# Fix LIBDIR from media-tv/kodi
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/kodi

		-DOPENGL_FOUND=$(usex opengl TRUE FALSE)
		-DOPENGLES2_FOUND=$(usex gles TRUE FALSE)
	)

	cmake-utils_src_configure
}
