# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit rpm nsplugins

DESCRIPTION="CryptoPro CAdES NPAPI plugin library."
HOMEPAGE="https://www.cryptopro.ru/products/cades/plugin/"

SRC_URI="
	amd64? (
		cprocsp-npcades-64-${PV}-4.x86_64.rpm
		lsb-cprocsp-cades-64-${PV}-4.x86_64.rpm
		lsb-cprocsp-ocsp-util-64-${PV}-4.x86_64.rpm
		lsb-cprocsp-tsp-util-64-${PV}-4.x86_64.rpm
	)
	x86? (
		cprocsp-npcades-${PV}-4.i486.rpm
		lsb-cprocsp-cades-${PV}-4.i486.rpm
		lsb-cprocsp-ocsp-util-${PV}-4.i486.rpm
		lsb-cprocsp-tsp-util-${PV}-4.i486.rpm
	)
"
IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
LICENSE="Crypto-Pro"

RESTRICT="fetch mirror"

S="${WORKDIR}"

RDEPEND="
	app-crypt/cryptoprocsp-uek
"

pkg_nofetch() {
        local download_url="https://www.cryptopro.ru/products/cades/plugin/get_2_0"

        einfo
        einfo " Due to restrictions, we cannot fetch the"
        einfo " distributables automagically."
        einfo
        einfo " 1. Visit ${download_url}"
        einfo " 2. Download cades_linux_*.tar.gz"
        einfo " 3. Unpack following files to \$DISTDIR:"
        einfo "		- cprocsp-npcades-*${PV}-4.*.rpm"
        einfo "		- lsb-cprocsp-cades-*${PV}-4.*.rpm"
        einfo "		- lsb-cprocsp-ocsp-util-*${PV}-4.*.rpm"
        einfo "		- lsb-cprocsp-tsp-util-*${PV}-4.*.rpm"
        einfo 
        einfo " Run emerge on this package again to complete"
        einfo 
}

pkg_setup() {
	if use amd64; then
		arch="amd64"
	else
		arch="ia32"
	fi
}

src_install() {
	insinto "/etc/opt/cprocsp"
	doins etc/opt/cprocsp/trusted_sites.html

	exeinto "/opt/cprocsp/bin/${arch}"
	doexe opt/cprocsp/bin/${arch}/{nmcades,ocsputil,tsputil}

	insinto /usr/$(get_libdir)
	for lib in opt/cprocsp/lib/${arch}/lib*.so*; do
		if [ -L ${lib} ]; then
			doins "${lib}"
		else
		    dolib.so "${lib}"
		fi
        done

	insinto "/opt/cprocsp/lib/hashes"
	doins -r opt/cprocsp/lib/hashes

	inst_plugin /usr/$(get_libdir)/libnpcades.so
}
