# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit subversion systemd

ESVN_REPO_URI="${OSCAM_ESVN_REPO_URI:-http://www.streamboard.tv/svn/oscam/trunk}"

DESCRIPTION="OSCam is an Open Source Conditional Access Module software"
HOMEPAGE="http://www.streamboard.tv/wiki/OSCam/en"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

PROTOCOLS="camd33 camd35 camd35_tcp cccam cccshare constcw gbox ghttp newcamd pandora radegast scam serial"
for share in ${PROTOCOLS}; do
	IUSE_PROTOCOLS+=" protocol_${share}"
done

READERS="bulcrypt conax cryptoworks dgcrypt dre griffin irdeto nagra nagra_merlin seca tongfang viaccess videoguard"
for card in ${READERS}; do
	IUSE_READERS+=" reader_${card}"
done

CARD_READERS="db2com drecas internal mp35 phoenix sc8in1 smargo stapi stapi5 stinger"
for cardreader in ${CARD_READERS}; do
	IUSE_CARDREADERS+=" cardreader_${cardreader}"
done

IUSE="${IUSE_PROTOCOLS} ${IUSE_READERS} ${IUSE_CARDREADERS}
	+anticasc cacheex cw_cycle_check debug +dvbapi ipv6 irdeto_guessing lcd led loadbalancing +monitor pcsc +reader +ssl touch usb +www jquery livelog clockfix"

# dvbapi www (WEBIF) jquery ipv6 livelog touch ssl debug monitor loadbalancing lcd led clockfix

RDEPEND="dev-libs/openssl
	usb? ( virtual/libusb:1 )
	pcsc? ( sys-apps/pcsc-lite )"
DEPEND="${RDEPEND}"

RESTRICT="mirror strip"

S="${WORKDIR}/${P}"

src_prepare() {
	sed -i "s:share/doc/oscam:share/doc/oscam-${PV}:" CMakeLists.txt || die "Failed to modify doc path"
	eapply_user
}

src_configure() {
	./config.sh --disable all							\
		$(usex dvbapi		"--enable HAVE_DVBAPI"		"")		\
		$(usex www		"--enable WEBIF"		"")		\
		$(usex jquery		"--enable WEBIF_JQUERY"		"")		\
		$(usex livelog		"--enable WEBIF_LIVELOG"	"")		\
		$(usex ipv6		"--enable IPV6SUPPORT"		"")		\
		$(usex touch		"--enable TOUCH"		"")		\
		$(usex ssl		"--enable WITH_SSL"		"")		\
		$(usex debug		"--enable WITH_DEBUG"		"")		\
		$(usex monitor		"--enable MODULE_MONITOR"	"")		\
		$(usex loadbalancing	"--enable WITH_LB"		"")		\
		$(usex lcd		"--enable LCDSUPPORT"		"")		\
		$(usex led		"--enable LEDSUPPORT"		"")		\
		$(usex clockfix		"--enable CLOCKFIX"		"")		\
											\
		$(usex protocol_camd33		"--enable MODULE_CAMD33"	"")	\
		$(usex protocol_camd35		"--enable MODULE_CAMD35"	"")	\
		$(usex protocol_camd35_tcp	"--enable MODULE_CAMD35_TCP"	"")	\
		$(usex protocol_cccam		"--enable MODULE_CCCAM"		"")	\
		$(usex protocol_cccshare	"--enable MODULE_CCCSHARE"	"")	\
		$(usex protocol_constcw		"--enable MODULE_CONSTCW"	"")	\
		$(usex protocol_gbox		"--enable MODULE_GBOX"		"")	\
		$(usex protocol_ghttp		"--enable MODULE_GHTTP"		"")	\
		$(usex protocol_newcamd		"--enable MODULE_NEWCAMD"	"")	\
		$(usex protocol_pandora		"--enable MODULE_PANDORA"	"")	\
		$(usex protocol_radegast	"--enable MODULE_RADEGAST"	"")	\
		$(usex protocol_scam		"--enable MODULE_SCAM"		"")	\
		$(usex protocol_serial		"--enable MODULE_SERIAL"	"")	\
											\
		$(usex reader_bulcrypt		"--enable READER_BULCRYPT"	"")	\
		$(usex reader_conax		"--enable READER_CONAX"		"")	\
		$(usex reader_cryptoworks	"--enable READER_CRYPTOWORKS"	"")	\
		$(usex reader_dgcrypt		"--enable READER_DGCRYPT"	"")	\
		$(usex reader_dre		"--enable READER_DRE"		"")	\
		$(usex reader_griffin		"--enable READER_GRIFFIN"	"")	\
		$(usex reader_irdeto		"--enable READER_IRDETO"	"")	\
		$(usex reader_nagra		"--enable READER_NAGRA"		"")	\
		$(usex reader_nagra_merlin	"--enable READER_NAGRA_MERLIN"	"")	\
		$(usex reader_seca		"--enable READER_SECA"		"")	\
		$(usex reader_tongfang		"--enable READER_TONGFANG"	"")	\
		$(usex reader_viaccess		"--enable READER_VIACCESS"	"")	\
		$(usex reader_videoguard	"--enable READER_VIDEOGUARD"	"")	\
											\
		$(usex cardreader_db2com	"--enable CARDREADER_DB2COM"	"")	\
		$(usex cardreader_drecas	"--enable CARDREADER_DRECAS"	"")	\
		$(usex cardreader_internal	"--enable CARDREADER_INTERNAL"	"")	\
		$(usex cardreader_mp35		"--enable CARDREADER_MP35"	"")	\
		$(usex cardreader_phoenix	"--enable CARDREADER_PHOENIX"	"")	\
		$(usex cardreader_sc8in1	"--enable CARDREADER_SC8IN1"	"")	\
		$(usex cardreader_smargo	"--enable CARDREADER_SMARGO"	"")	\
		$(usex cardreader_stapi		"--enable CARDREADER_STAPI"	"")	\
		$(usex cardreader_stapi5	"--enable CARDREADER_STAPI5"	"")	\
		$(usex cardreader_stinger	"--enable CARDREADER_STINGER"	"")

}

src_compile() {
	emake						\
		$(usex usb	"USE_LIBUSB=1"	"")	\
		$(usex pcsc	"USE_PCSC=1"	"")
}

src_install() {
	newbin Distribution/oscam-*.debug oscam

	if use cardreader_smargo; then
		newbin "${WORKDIR}/${P}/Distribution/list_smargo-1.20_svn-x86_64-pc-linux-gnu-ssl-libusb" list_smargo
	fi

	dobin "${FILESDIR}/oscam_watchdog.sh" || die "dobin oscam_watchdog.sh failed"

	doman "${WORKDIR}/${P}/Distribution/doc/man"/*
	#dohtml "${WORKDIR}/${P}/Distribution/doc/html"

	insinto "/etc/${PN}"
	doins -r Distribution/doc/example/*
	#fperms 0755 /etc/${PN} # ??? all executable ???

	systemd_dounit "${FILESDIR}/${PN}.service"

	newinitd "${FILESDIR}/${PN}.initd" oscam
	newconfd "${FILESDIR}/${PN}.confd" oscam

	keepdir "/var/log/${PN}/emm"

	einstalldocs

	#die "--- ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ ---"
}

pkg_postinst() {
	einfo "Please refer to the wiki for assistance with the setup"
	einfo "located at ${HOMEPAGE}"
}
