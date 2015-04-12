# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="PC/SC components for CryptoPro CSP readers."

IUSE="ccid"
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	ccid? ( app-crypt/ccid )
	app-crypt/lsb-cprocsp-rdr
	sys-apps/pcsc-lite
"

CRYPTOPRO_BINARIES=( list_pcsc )
CRYPTOPRO_REGISTER_LIBS=(
	libpcsclite.so
	librdrpcsc.so
	librdrric.so
)
CRYPTOPRO_UNSET_SECTIONS=(
	'\config\KeyDevices\PCSC'
	'\config\KeyCarriers\OSCAR'
	'\config\KeyCarriers\OSCAR2'
	'\config\KeyCarriers\TRUST'
	'\config\KeyCarriers\TRUSTS'
	'\config\KeyCarriers\TRUSTD'
)

pkg_postinst() {
	cryptopro_pkg_postinst

	cryptopro_add_ini '\config\KeyDevices\PCSC' string DLL librdrpcsc.so
	cryptopro_add_ini '\config\KeyDevices\PCSC' long Group 1
	cryptopro_add_ini '\config\KeyDevices\PCSC\PNP PCSC\Default' string Name 'All PC/SC readers'
	cryptopro_add_ini '\config\KeyCarriers\OSCAR' string DLL librdrric.so
	cryptopro_add_ini '\config\KeyCarriers\OSCAR2' string DLL librdrric.so
	cryptopro_add_ini '\config\KeyCarriers\TRUST' string DLL librdrric.so
	cryptopro_add_ini '\config\KeyCarriers\TRUSTS' string DLL librdrric.so
	cryptopro_add_ini '\config\KeyCarriers\TRUSTD' string DLL librdrric.so

	cryptopro_add_hardware media oscar 'Оскар'
	cpconfig -hardware media -configure oscar -add hex atr 0000000000000043525950544f5052
	cpconfig -hardware media -configure oscar -add hex mask 00000000000000ffffffffffffffff
	cpconfig -hardware media -configure oscar -add string folders 0B00

	cryptopro_add_hardware media oscar2 'Oscar CSP 2.0' CSP
	cpconfig -hardware media -configure oscar2 -connect CSP -add hex atr 000000000000004350435350010102
	cpconfig -hardware media -configure oscar2 -connect CSP -add hex mask 00000000000000ffffffffffffffff
	cpconfig -hardware media -configure oscar2 -connect CSP -add string folders 0B00
	cpconfig -hardware media -configure oscar2 -connect CSP -add long size_1 60
	cpconfig -hardware media -configure oscar2 -connect CSP -add long size_2 70
	cpconfig -hardware media -configure oscar2 -connect CSP -add long size_4 60
	cpconfig -hardware media -configure oscar2 -connect CSP -add long size_5 70
	cpconfig -hardware media -configure oscar2 -connect CSP -add long size_6 62

	cryptopro_add_hardware media oscar2 'Channel K' KChannel
	cpconfig -hardware media -configure oscar2 -connect KChannel -add hex atr 000000000000004350435350010101
	cpconfig -hardware media -configure oscar2 -connect KChannel -add hex mask 00000000000000ffffffffffffffff
	cpconfig -hardware media -configure oscar2 -connect KChannel -add string folders 0B00
	cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_1 56
	cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_2 36
	cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_4 56
	cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_5 36
	cpconfig -hardware media -configure oscar2 -connect KChannel -add long size_6 62

	cryptopro_add_hardware media TRUST Magistra
	cpconfig -hardware media -configure TRUST -add hex atr 3b9e00008031c0654d4700000072f7418107
	cpconfig -hardware media -configure TRUST -add hex mask ffff0000ffffffffffff300000ffffffffff
	cpconfig -hardware media -configure TRUST -add string folders "A\\B\\C\\D\\E\\F\\G\\H"

	cryptopro_add_hardware media TRUSTS 'Magistra SocCard'
	cpconfig -hardware media -configure TRUSTS -add hex atr 3b9a00008031c0610072f7418107
	cpconfig -hardware media -configure TRUSTS -add hex mask ffff0000ffffffff30ffffffffff
	cpconfig -hardware media -configure TRUSTS -add string folders "A\\B\\C\\D"

	cryptopro_add_hardware media TRUSTD 'Magistra Debug'
	cpconfig -hardware media -configure TRUSTD -add hex atr 3b9800008031c072f7418107
	cpconfig -hardware media -configure TRUSTD -add hex mask ffff0000ffffffffffffffff
	cpconfig -hardware media -configure TRUSTD -add string folders "A\\B\\C\\D\\E\\F\\G\\H"
}

pkg_prerm() {
	cryptopro_remove_hardware media oscar
	cryptopro_remove_hardware media oscar2
	cryptopro_remove_hardware media TRUST
	cryptopro_remove_hardware media TRUSTS
	cryptopro_remove_hardware media TRUSTD

	cryptopro_pkg_prerm
}
