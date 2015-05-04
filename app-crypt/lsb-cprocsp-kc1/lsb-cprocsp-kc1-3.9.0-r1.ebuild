# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="Crypto-Pro CSP library."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	app-crypt/lsb-cprocsp-rdr
"

CRYPTOPRO_REGISTER_LIBS=(
	libcsp.so
	librdrrndmbio_tui.so
)
CRYPTOPRO_UNSET_SECTIONS=( '\config\Random\bio_tui' )

src_install() {
	cryptopro_src_install

	dodir /var/opt/cprocsp/keys
	fowners root:cprousers /var/opt/cprocsp/keys
	fperms 770 /var/opt/cprocsp/keys
}

pkg_postinst() {
	cryptopro_pkg_postinst

	cryptopro_add_hardware reader hdimage "Структура дискеты на жестком диске"

	cryptopro_add_ini '\config\Random\bio_tui' string DLL librdrrndmbio_tui.so
	cryptopro_add_hardware rndm bio_tui "Биологический текстовый" "" 5
	cryptopro_add_provider "Crypto-Pro GOST R 34.10-2001 KC1 CSP" 75\
                libcsp.so CPCSP_GetFunctionTable
}

pkg_prerm() {
	cryptopro_remove_hardware reader hdimage
	cryptopro_remove_hardware rndm bio_tui
	cryptopro_remove_provider "Crypto-Pro GOST R 34.10-2001 KC1 CSP"

	cryptopro_pkg_prerm
}
