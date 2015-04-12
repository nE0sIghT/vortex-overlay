# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5

inherit cryptopro

DESCRIPTION="Meta package for CryptoPro UEC CSP."

SRC_URI=""

IUSE="nsplugin"
SLOT="0"

KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND="${DEPEND}

	~app-crypt/cprocsp-rdr-pcsc-3.9.0
	~app-crypt/cprocsp-rdr-uec-3.9.0
	~app-crypt/lsb-cprocsp-base-3.9.0
	~app-crypt/lsb-cprocsp-rdr-3.9.0
	~app-crypt/lsb-cprocsp-kc1-3.9.0
	~app-crypt/lsb-cprocsp-fkc-3.9.0

	nsplugin? ( ~www-plugins/cprocsp-npcades-3.9.0 )
"

src_install() { :; }

pkg_postinst() {
	einfo "Installing UEC certificates"
	for certificate in {uec,uec2}; do
		ebegin "${certificate}"
		/opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"/certmgr -inst -file "${FILESDIR}"/"${certificate}".cer -store=Root
		eend $?
	done

	einfo "Configuring KC1 base provider"
	for param in {"Base Function Table Name","Base CP Module Name"}; do
		cpconfig -ini "\\cryptography\\Defaults\\Provider\\Crypto-Pro GOST R 34.10-2001 FKC CSP\\${param}" -delparam
	done

	cryptopro_add_ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 FKC CSP' \
	    string 'Base Function Table Name' CPCSP_GetFunctionTable
	cryptopro_add_ini '\cryptography\Defaults\Provider\Crypto-Pro GOST R 34.10-2001 FKC CSP' \
	    string 'Base CP Module Name' libcsp.so
}
