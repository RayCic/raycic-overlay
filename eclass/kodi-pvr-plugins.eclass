# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: kodi-pvr-plugins.eclass
# @MAINTAINER:
# Raimonds Cicans <ray@apollo.lv>
# @BLURB: Eclass for Kodi PVR plugin packages
# @DESCRIPTION:
# The kodi-pvr-plugins eclass contains miscellaneous, useful functions for Kodi PVR plugin packages.
#

inherit cmake-utils

case "${EAPI:-0}" in
	5)
		;;
	0|1|2|3|4)
		die "EAPI=\"${EAPI}\" is not supported anymore"
		;;
	*)
		die "EAPI=\"${EAPI}\" is not supported yet"
		;;
esac

upstream_pn=${PN#kodi-}
upstream_pn=${upstream_pn//-/.}

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/kodi-pvr/${upstream_pn}.git"
	EGIT_BRANCH="Isengard"
	inherit git-r3
else
	SRC_URI="https://github.com/kodi-pvr/${upstream_pn}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"

DEPEND="dev-libs/kodi-platform
	>=media-tv/kodi-15"

RDEPEND="${DEPEND}
	!media-plugins/xbmc-addon-pvr"

EXPORT_FUNCTIONS src_configure src_prepare

kodi-pvr-plugins_src_configure() {
	local mycmakeargs=()

	# Fix LIBDIR from media-tv/kodi
	mycmakeargs+=(
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/kodi
	)

	cmake-utils_src_configure
}

# Delete unneeded LINGUAS and warn about unsupported
kodi-pvr-plugins_src_prepare() {
	cd $upstream_pn/resources/language

	shopt -s nocasematch

	local found_linguas=""

	for f in *; do
		local lang=${f#resource.language.}
		local found=0

		for l in ${LINGUAS}; do
			if [[ ${lang} == ${l}* ]]; then
				found=1
				found_linguas+=" ${l}"
			fi
		done

		[ ${found} -eq 1 ] || rm -rf "${f}" || die
	done

	shopt -u nocasematch

	local not_found_linguas=""

	for l in ${LINGUAS}; do
		for f in ${found_linguas}; do
			[ "${l}" == "${f}" ] && continue 2
		done

		not_found_linguas+=" ${l}"
	done

	[ -z "${not_found_linguas}" ] || ewarn "Not supported LINGUAS:${not_found_linguas}"
}
