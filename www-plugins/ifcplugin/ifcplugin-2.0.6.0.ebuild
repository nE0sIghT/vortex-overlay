# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit user unpacker nsplugins

DESCRIPTION="Crypto Interface Web Browser Plugin"
HOMEPAGE="https://ds-plugin.gosuslugi.ru/plugin/upload/Index.spr"

SRC_URI="
	x86? ( https://ds-plugin.gosuslugi.ru/plugin/htdocs/plugin/IFCPlugin-i386.deb -> ${P}.x86.deb )
	amd64? ( https://ds-plugin.gosuslugi.ru/plugin/htdocs/plugin/IFCPlugin-x86_64.deb -> ${P}.amd64.deb )
"
IUSE=""
SLOT="0"

KEYWORDS="-* amd64 x86"
LICENSE="freedist"

S="${WORKDIR}"

RDEPEND="
	app-crypt/ccid
	sys-apps/pcsc-lite
"

# Ignore QA warnings in these closed-source binaries, since we can't fix them:
QA_PREBUILT="usr/*"

pkg_setup() {
	enewgroup ifcusers
}

src_install() {
	local logdir="/var/log/ifc/engine_logs"

	# PLUGINS_DIR comes from nsplugins.eclass
	exeinto /usr/$(get_libdir)/${PLUGINS_DIR}
	doexe usr/lib/mozilla/plugins/npIFCPlugin.so

	insinto /usr/$(get_libdir)/${PLUGINS_DIR}
	doins -r usr/lib/mozilla/plugins/lib

	insinto "/etc"
	doins etc/ifc.cfg

	dodir "${logdir}"
	fowners root:ifcusers "${logdir}"
	fperms 770 "${logdir}"
}

pkg_postinst() {
	elog "In order to use ifcplugin add yourself to the 'ifcusers' group"
}
