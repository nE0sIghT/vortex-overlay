# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="CryptoPro TSP client."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	app-crypt/lsb-cprocsp-capilite
"

CRYPTOPRO_BINARIES=( tsputil )
