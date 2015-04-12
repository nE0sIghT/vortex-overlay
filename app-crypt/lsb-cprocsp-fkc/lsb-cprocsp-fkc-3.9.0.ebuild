# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="Crypto-Pro FKC CSP."
SRC_URI="
        ${PN}-64-${PV}-4.x86_64.rpm
"

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64"

RDEPEND="
	app-crypt/lsb-cprocsp-rdr
	app-crypt/lsb-cprocsp-capilite
"

CRYPTOPRO_SBINARIES=( configure_base_prov.sh )
CRYPTOPRO_REGISTER_LIBS=(
	libcspfkc.so
	libcpuifkc.so
)

pkg_postinst() {
        cryptopro_pkg_postinst

	cryptopro_add_provider "Crypto-Pro GOST R 34.10-2001 FKC CSP" 75\
		libcspfkc.so CPFKC_GetFunctionTable\
		libcsp.so CPCSP_GetFunctionTable

        ebegin  "Installing temp license..."
        cpconfig -license -fkc -set 36360-U0030-01C97-HQ92Y-1EY1K
        eend $?
}

pkg_prerm() {
	cryptopro_pkg_prerm
	cryptopro_remove_provider "Crypto-Pro GOST R 34.10-2001 FKC CSP"
}
