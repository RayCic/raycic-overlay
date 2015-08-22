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

local my_depend=""

case "${PV:-0}" in
	"15.9999")
		EGIT_REPO_URI="https://github.com/kodi-pvr/${upstream_pn}.git"
		EGIT_BRANCH="Isengard"
		my_depend="=media-tv/kodi-15*"
		inherit git-r3
		;;
	"9999")
		EGIT_REPO_URI="https://github.com/kodi-pvr/${upstream_pn}.git"
		my_depend="=media-tv/kodi-9999"
		inherit git-r3
		;;
	*)
		die "Version=\"${PV}\" is not supported"
		;;
esac

IUSE="debug"
LICENSE="GPL-2+"
SLOT="0"

DEPEND="dev-libs/kodi-platform
	${my_depend}"

RDEPEND="${DEPEND}
	!media-plugins/xbmc-addon-pvr"

EXPORT_FUNCTIONS src_configure src_prepare

kodi-pvr-plugins_src_configure() {
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

	cmake-utils_src_configure
}

# Delete unneeded LINGUAS and warn about unsupported
kodi-pvr-plugins_src_prepare() {
	local langdir="${upstream_pn}/resources/language"

	if [ -d "${langdir}" ]; then

		cd "${langdir}"

		shopt -s nocasematch

		local found_linguas=""

		for f in resource.language.*; do
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
	else
		ewarn "Ebuild do not support LINGUAS at all"
	fi
}
