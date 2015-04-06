# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit nsplugins cryptopro

DESCRIPTION="CryptoPro CAdES NPAPI plugin library."

SLOT="0"

KEYWORDS="-* ~amd64"
RESTRICT="fetch mirror"

RDEPEND="
	app-crypt/lsb-cprocsp-cades
	app-crypt/cprocsp-rdr-gui
"

pkg_nofetch() {
        local CRYPTOPRO_FETCH="https://www.cryptopro.ru/products/cades/plugin/get"
	cryptopro_pkg_nofetch
}


src_install() {
	insinto "/etc/opt/cprocsp"
	doins etc/opt/cprocsp/trusted_sites.html

	cryptopro_src_install

	inst_plugin /usr/$(get_libdir)/libnpcades.so
}
