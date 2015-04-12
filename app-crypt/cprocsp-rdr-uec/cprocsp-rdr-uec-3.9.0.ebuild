# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="UEC support module for CryptoPro CSP."

IUSE=""
SLOT="0"

SRC_URI="
	${PN}-64-${PV}-4.x86_64.rpm
"
KEYWORDS="-* ~amd64"

RDEPEND="
	app-crypt/cprocsp-rdr-pcsc
	app-crypt/lsb-cprocsp-capilite
	app-crypt/lsb-cprocsp-rdr
"

src_install() {
	cryptopro_src_install

	insinto /var/opt/cprocsp/tmp
	doins var/opt/cprocsp/tmp/cauec.p7b
}
