# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils virtualx pax-utils git-r3

DESCRIPTION="VDPAU driver with VA-API/OpenGL backend."
HOMEPAGE="https://github.com/i-rinat/libvdpau-va-gl/"
EGIT_REPO_URI="https://github.com/i-rinat/libvdpau-va-gl.git"

LICENSE="MIT-with-advertising"
SLOT="0"

DEPEND="virtual/opengl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libva[X]"
RDEPEND="${DEPEND}
	x11-libs/libvdpau"

DOCS=(ChangeLog README.md)

src_compile() {
	cmake-utils_src_compile
	if use test; then
		cmake-utils_src_make build-tests
		pax-mark m "${BUILD_DIR}"/tests/test-*
	fi
}

src_test() {
	VIRTUALX_COMMAND=cmake-utils_src_test virtualmake
}
