# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 flag-o-matic go-module git-r3

DESCRIPTION="Library and podman tool for running OCI-based containers in Pods"
HOMEPAGE="https://github.com/containers/libpod/"
EGIT_COMMIT="v${PV}"
EGIT_REPO_URI="https://github.com/containers/libpod.git"
LICENSE="Apache-2.0 BSD BSD-2 CC-BY-SA-4.0 ISC MIT MPL-2.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="apparmor btrfs device-mapper +rootless selinux +varlink"
RESTRICT="test"

COMMON_DEPEND="
	app-crypt/gpgme:=
	>=app-emulation/conmon-2.0.0
	>=app-emulation/runc-1.0.0_rc6
	dev-libs/libassuan:=
	dev-libs/libgpg-error:=
	sys-libs/libseccomp:=

	apparmor? ( sys-libs/libapparmor )
	btrfs? ( sys-fs/btrfs-progs )
	device-mapper? ( sys-fs/lvm2 )
	rootless? ( app-emulation/slirp4netns )
	selinux? ( sys-libs/libselinux:= )
"
DEPEND="
	${COMMON_DEPEND}
	dev-go/go-md2man"
RDEPEND="${COMMON_DEPEND}"

src_compile() {
	# Filter unsupported linker flags
	filter-flags '-Wl,*'

	local buildtags=""
	buildtags+="$(usev apparmor) "
	buildtags+="$(usev selinux) "
	buildtags+="$(usev varlink) "
	buildtags+="$(usex btrfs '' exclude_graphdriver_btrfs) "
	buildtags+="$(usex device-mapper '' exclude_graphdriver_devicemapper) "

	export -n GOCACHE XDG_CACHE_HOME
	GOPATH="${S}/_output" \
		emake all \
			BUILDTAGS="$buildtags"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install

	insinto /etc/containers
	newins test/registries.conf registries.conf.example
	newins test/policy.json policy.json.example

	newinitd "${FILESDIR}"/podman.initd podman

	insinto /etc/logrotate.d
	newins "${FILESDIR}/podman.logrotated" podman

	dobashcomp completions/bash/*

	keepdir /var/lib/containers
}

pkg_preinst() {
	LIBPOD_ROOTLESS_UPGRADE=false
	if use rootless; then
		has_version 'app-emulation/libpod[rootless]' || LIBPOD_ROOTLESS_UPGRADE=true
	fi
}

pkg_postinst() {
	local want_newline=false
	if [[ ! ( -e ${EROOT%/*}/etc/containers/policy.json && -e ${EROOT%/*}/etc/containers/registries.conf ) ]]; then
		elog "You need to create the following config files:"
		elog "/etc/containers/registries.conf"
		elog "/etc/containers/policy.json"
		elog "To copy over default examples, use:"
		elog "cp /etc/containers/registries.conf{.example,}"
		elog "cp /etc/containers/policy.json{.example,}"
		want_newline=true
	fi
	if [[ ${LIBPOD_ROOTLESS_UPGRADE} == true ]] ; then
		${want_newline} && elog ""
		elog "For rootless operation, you need to configure subuid/subgid"
		elog "for user running podman. In case subuid/subgid has only been"
		elog "configured for root, run:"
		elog "usermod --add-subuids 1065536-1131071 <user>"
		elog "usermod --add-subgids 1065536-1131071 <user>"
		want_newline=true
	fi
}
