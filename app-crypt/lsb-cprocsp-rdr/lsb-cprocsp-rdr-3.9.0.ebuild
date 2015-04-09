# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="CryptoPro CSP readers."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64"

RDEPEND="
	app-crypt/lsb-cprocsp-base
"

CRYPTOPRO_REGISTER_LIBS=(
	librdrfat12.so
	librdrrdr.so
	librdrrndm.so
	librdrdsrf.so
	libcpui.so
)

src_install() {
	local CRYPTOPRO_BINARIES=(
		cpverify
		csptest
		wipefile
	)
	local CRYPTOPRO_SBINARIES=(
		cpconfig
		mount_flash.sh
		set_driver_license.sh
	)
	cryptopro_src_install

	insinto /etc/opt/cprocsp
	doins etc/opt/cprocsp/config64.ini
}

pkg_postinst() {
	cryptopro_pkg_postinst

	cryptopro_add_hardware rndm cpsd КПИМ 3

	"${CPCONFIG}" -ini '\config\Random\cpsd\Default' -add string '/db1/kis_1' /var/opt/cprocsp/dsrf/db1/kis_1
	"${CPCONFIG}" -ini '\config\Random\cpsd\Default' -add string '/db2/kis_1' /var/opt/cprocsp/dsrf/db2/kis_1

#	${CPCONFIG} -license -view > /dev/null
#	if [ $? -ne 0 ]; then
#		ebegin  "Installing temp license..."
#		"${CPCONFIG}" -license -set x
#		eend $?
#	fi
}

pkg_prerm() {
	cryptopro_pkg_prerm
	cryptopro_remove_hardware rndm cpsd
}
