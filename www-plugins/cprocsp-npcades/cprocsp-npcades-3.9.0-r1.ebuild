# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit nsplugins cryptopro

DESCRIPTION="CryptoPro CAdES NPAPI plugin library."

SRC_URI="
	${PN}-64-${PV}-4.x86_64.rpm
"
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

	insinto /opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"
	newins opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"/libnpcades.so.1.0.0 libnpcades.so
	for file in {libnpcades.so,libnpcades.so.1,libnpcades.so.1.0.0}; do
		rm opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"/"${file}"
	done

	cryptopro_src_install

	inst_plugin /opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"/libnpcades.so
}

pkg_postinst() {
	cryptopro_pkg_postinst
	cryptopro_register_lib /opt/cprocsp/lib/"${CRYPTOPRO_ARCH}" libnpcades.so
}

pkg_prerm() {
	cryptopro_pkg_prerm
	cpconfig -ini "\\config\\apppath\\libnpcades.so" -delparam
}
