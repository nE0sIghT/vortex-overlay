# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="Crypto-Pro CSP library."

SRC_URI="${P}-4.noarch.rpm"

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64"

src_install() {
        cryptopro_src_install

	insinto /etc/opt/cprocsp
	doins etc/opt/cprocsp/release
	doins etc/opt/cprocsp/stunnel.conf

	insinto /etc/profile.d
	doins etc/profile.d/cprocsp.sh

	insinto /opt/cprocsp/share
	doins -r opt/cprocsp/share/locale

	insinto /var/opt
	doins -r var/opt/cprocsp

	doman opt/cprocsp/share/man/man8/certmgr.8
	doman opt/cprocsp/share/man/man8/stunnel.8
	doman opt/cprocsp/share/man/man8/stunnel.ru.8

	if use amd64; then
		dosym ld-linux-x86-64.so.2 /$(get_libdir)/ld-lsb-x86-64.so.3
	else
		dosym ld-linux.so.2 /$(get_libdir)/ld-lsb.so.3
	fi
}
