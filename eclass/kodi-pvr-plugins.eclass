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

case "${PV:-0}" in
	"15.9999")
		EGIT_BRANCH="Isengard"
		DEPEND="=media-tv/kodi-15*
			=dev-libs/kodi-platform-15*"
		;;
	"16.9999")
		EGIT_BRANCH="Jarvis"
		DEPEND="=media-tv/kodi-16*
			=dev-libs/kodi-platform-16*"
		;;
	"9999")
		DEPEND="=media-tv/kodi-9999
			=dev-libs/kodi-platform-9999"
		;;
	*)
		die "Version=\"${PV}\" is not supported"
		;;
esac

# handled by cmake-utils
IUSE="debug"

# all packages originate from same source with same license
LICENSE="GPL-2+"

# media-tv/kodi is not slotted so there is no reason to slot plugins
SLOT="0"

RDEPEND="${DEPEND}
	!media-plugins/xbmc-addon-pvr"

EXPORT_FUNCTIONS src_configure src_prepare

# Fix some build system problems
kodi-pvr-plugins_src_configure() {
	local mycmakeargs=(
		# Fix LIBDIR from media-tv/kodi
		-DCMAKE_INSTALL_LIBDIR="${EPREFIX}"/usr/$(get_libdir)/kodi
	)

	cmake-utils_src_configure
}

# Delete unneeded LINGUAS and warn about unsupported
# Cases:
#   1) LINGUAS unset or empty - install all languages supported by upstream
#   2) LINGUAS fully consist of things not recongnized as supported languages -
#        all languages are deleted and not recongnized substrings are displayed.
#   3) LINGUAS contains at least one or more supported by upstream languages -
#        all recognized languages are installed and other are deleted.
#        Not recongnized language substrings are displayed.
kodi-pvr-plugins_src_prepare() {
	[ -z "${LINGUAS}" ] && return

	local langdir="${upstream_pn}/resources/language"

	[ ! -d "$langdir" ] && ewarn "Upstream do not support LINGUAS at all" && return

	cd "$langdir" || die

	local found_linguas=""

	for f in resource.language.*; do
		local lang=${f#resource.language.}
		local found=0

		for l in ${LINGUAS}; do
			if [[ ${lang} == ${l,,}* ]]; then
				found=1
				found_linguas+="$l "
			fi
		done

		[ ${found} -eq 1 ] || rm -rf "$f" || die
	done

	local not_found_linguas=""

	for l in ${LINGUAS}; do
		has ${l} ${found_linguas} || not_found_linguas+=" $l"
	done

	[ -z "${not_found_linguas}" ] || ewarn "Not supported LINGUAS:${not_found_linguas}"
}
