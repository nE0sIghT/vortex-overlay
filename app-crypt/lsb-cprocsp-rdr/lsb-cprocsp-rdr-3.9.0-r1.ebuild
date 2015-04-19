# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="CryptoPro CSP readers."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	app-crypt/lsb-cprocsp-base
	net-misc/curl
"

CRYPTOPRO_REGISTER_LIBS=(
	librdrfat12.so
	librdrrdr.so
	librdrrndm.so
	librdrdsrf.so
	libcpui.so
	libcurl.so
)
CRYPTOPRO_UNSET_PARAMS=(
	'\config\apppath\mount_flash.sh'
)
CRYPTOPRO_UNSET_SECTIONS=(
	'\config\KeyDevices\FLASH'
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

	# libjemalloc.so conflicts with dev-libs/jemalloc
	rm opt/cprocsp/lib/${CRYPTOPRO_ARCH}/libjemalloc.so

	cryptopro_src_install

	insinto /etc/opt/cprocsp
	doins etc/opt/cprocsp/"$(cryptopro_get_config)"
}

pkg_postinst() {
	cryptopro_pkg_postinst

	cryptopro_add_ini '\config\apppath' string \
		mount_flash.sh /opt/cprocsp/sbin/amd64/mount_flash.sh
	cryptopro_add_ini '\config\KeyDevices\FLASH' \
		string Dll librdrfat12.so
	cryptopro_add_ini '\config\KeyDevices\FLASH' string \
		Script mount_flash.sh
	cryptopro_add_hardware reader FLASH FLASH

	cryptopro_add_hardware rndm cpsd КПИМ "" 3
	cryptopro_add_ini '\config\Random\cpsd\Default' string \
		'/db1/kis_1' /var/opt/cprocsp/dsrf/db1/kis_1
	cryptopro_add_ini '\config\Random\cpsd\Default' string \
		'/db2/kis_1' /var/opt/cprocsp/dsrf/db2/kis_1

	cpconfig -license -view > /dev/null
	if [ $? -ne 0 ]; then
		ebegin  "Installing default 3 month license..."
		cpconfig -license -set 39390-Z0037-EA3YG-GRQED-E6LPZ
		eend $?

		elog "Your license will expire in 3 months."
		elog "In order to continue using this software after that"
		elog "you must buy proper license and set it using"
		elog "	cpconfig -license -set <your license>"
	fi
}

pkg_prerm() {
	cryptopro_remove_hardware reader FLASH
	cryptopro_remove_hardware rndm cpsd

	cryptopro_pkg_prerm
}
