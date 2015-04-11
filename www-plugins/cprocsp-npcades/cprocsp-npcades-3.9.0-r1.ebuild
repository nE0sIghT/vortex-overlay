# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit nsplugins cryptopro

DESCRIPTION="CryptoPro CAdES NPAPI plugin library."

SLOT="0"

KEYWORDS="-* ~amd64"

RDEPEND="
	app-crypt/lsb-cprocsp-cades
	app-crypt/cprocsp-rdr-gui-gtk
	dev-libs/libxml2
"

pkg_nofetch() {
        local CRYPTOPRO_FETCH="https://www.cryptopro.ru/products/cades/plugin/get"
	cryptopro_pkg_nofetch
}


src_install() {
	insinto /etc/opt/cprocsp
	doins etc/opt/cprocsp/trusted_sites.html

	# For some weird reason Firefox refuses to load plugin
	# if it's symlinked
	dodir /usr/$(get_libdir)/${PLUGINS_DIR}
	insinto /usr/$(get_libdir)/${PLUGINS_DIR}
	newins opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"/libnpcades.so.1.0.0 libnpcades.so

	cryptopro_src_install
}

pkg_postinst() {
	cryptopro_pkg_postinst
	cpconfig -ini '\config\apppath' \
		-add string libnpcades.so /usr/$(get_libdir)/${PLUGINS_DIR}/libnpcades.so
}

pkg_prerm() {
	cryptopro_pkg_prerm
	cpconfig -ini "\\config\\apppath\\libnpcades.so" -delparam
}
