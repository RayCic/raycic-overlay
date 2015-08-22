# Copyright 1999-2015 Gentoo Foundation
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
	local mycmakeargs=()

	# Fix LIBDIR from media-tv/kodi
	mycmakeargs+=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/kodi
	)

	if use debug; then
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=Debug
		)
	else
		mycmakeargs+=(
			-DCMAKE_BUILD_TYPE=Release
		)
	fi

	if use opengl; then
		mycmakeargs+=(
			-DOPENGL_FOUND=TRUE
		)
	else
		mycmakeargs+=(
			-DOPENGL_FOUND=FALSE
		)
	fi

	if use gles; then
		mycmakeargs+=(
			-DOPENGLES2_FOUND=TRUE
		)
	else
		mycmakeargs+=(
			-DOPENGLES2_FOUND=FALSE
		)
	fi

	cmake-utils_src_configure
}
