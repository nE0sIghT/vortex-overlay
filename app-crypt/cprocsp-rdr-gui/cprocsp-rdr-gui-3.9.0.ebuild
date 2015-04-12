# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="GUI components for CryptoPro CSP readers."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	app-crypt/lsb-cprocsp-rdr
	x11-libs/motif:2.2
"
CRYPTOPRO_REGISTER_LIBS=(
	librdrrndmbio_gui.so
	libxcpui.so
	libxcpuifkc.so
)

CRYPTOPRO_UNSET_SECTIONS=(
	'\config\Random\bio_gui'
)

pkg_postinst() {
	cryptopro_pkg_postinst

	cryptopro_add_ini '\config\Random\bio_gui' string DLL librdrrndmbio_gui.so
	cryptopro_add_hardware rndm bio_gui 'rndm GUI' "" 4
}

pkg_prerm() {
	cryptopro_remove_hardware rndm bio_gui
	cryptopro_pkg_prerm
}
