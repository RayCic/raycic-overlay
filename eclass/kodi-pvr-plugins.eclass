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

inherit git-r3 cmake-utils

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

EGIT_REPO_URI="https://github.com/kodi-pvr/${upstream_pn}.git"

local my_depend=""

case "${PV:-0}" in
	"15.9999")
		EGIT_BRANCH="Isengard"
		my_depend="=media-tv/kodi-15*"
		;;
	"9999")
		my_depend="=media-tv/kodi-9999"
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
	local mycmakeargs=(
		# Fix LIBDIR from media-tv/kodi
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/kodi
	)

	cmake-utils_src_configure
}

# Delete unneeded LINGUAS and warn about unsupported
kodi-pvr-plugins_src_prepare() {
	local langdir="${upstream_pn}/resources/language"

	if [ -d "${langdir}" ]; then

		cd "${langdir}" || die

		[ -z "${LINGUAS}" ] && ewarn "LINGUAS variable not defined or empty - all language files will be deleted"

		shopt -s nocasematch

		local found_linguas=""

		for f in resource.language.*; do
			local lang=${f#resource.language.}
			local found=0

			for l in ${LINGUAS}; do
				if [[ ${lang} == ${l}* ]]; then
					found=1
					found_linguas+=" $l "
				fi
			done

			[ ${found} -eq 1 ] || rm -rf "$f" || die
		done

		shopt -u nocasematch

		local not_found_linguas=""

		for l in ${LINGUAS}; do
			[[ $found_linguas =~ " $l " ]] || not_found_linguas+=" $l"
		done

		[ -z "${not_found_linguas}" ] || ewarn "Not supported LINGUAS:${not_found_linguas}"
	else
		ewarn "Upstream do not support LINGUAS at all"
	fi
}
