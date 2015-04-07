# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5

inherit cryptopro

DESCRIPTION="Meta package for CryptoPro UEC CSP."

SRC_URI=""

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64"

DEPEND="
	=app-crypt/lsb-cprocsp-capilite-3.9.0
"
RDEPEND="
	${DEPEND}

	=app-crypt/cprocsp-rdr-pcsc-3.9.0
	=app-crypt/cprocsp-rdr-uec-3.9.0
	=app-crypt/lsb-cprocsp-base-3.9.0
	=app-crypt/lsb-cprocsp-rdr-3.9.0
	=app-crypt/lsb-cprocsp-kc1-3.9.0
	=app-crypt/lsb-cprocsp-fkc-3.9.0
"
