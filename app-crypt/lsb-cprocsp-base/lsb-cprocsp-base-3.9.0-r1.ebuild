# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit user cryptopro

DESCRIPTION="Crypto-Pro CSP library."

SRC_URI="${P}-4.noarch.rpm"

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"

pkg_nofetch() {
	cryptopro_pkg_nofetch

	if use x86; then
		eerror "Attention!"
		eerror "You must use rpm package from linux-amd64 distributive!"
		eerror
	fi
}

pkg_setup() {
	enewgroup cprousers
}

src_install() {
	cryptopro_src_install

	insinto /etc/opt/cprocsp
	doins etc/opt/cprocsp/release
	doins etc/opt/cprocsp/stunnel.conf

	insinto /etc/profile.d
	doins etc/profile.d/cprocsp.sh

	insinto /opt/cprocsp/share
	doins -r opt/cprocsp/share/locale

	keepdir /var/opt/cprocsp
	fowners root:cprousers /var/opt/cprocsp
	fperms 750 /var/opt/cprocsp

	for dir in {db1,db2}; do
		keepdir /var/opt/cprocsp/dsrf/"${dir}"
		fowners root:cprousers /var/opt/cprocsp/dsrf/"${dir}"
		fperms 750 /var/opt/cprocsp/dsrf/"${dir}"
	done

	keepdir /var/opt/cprocsp/mnt
	fperms 710 /var/opt/cprocsp/mnt

	for dir in {0,1,2,3,4,5,6,7}; do
		keepdir /var/opt/cprocsp/mnt/"${dir}"
		fowners root:cprousers /var/opt/cprocsp/mnt/"${dir}"
		fperms 770 /var/opt/cprocsp/mnt/"${dir}"
	done

	keepdir /var/opt/cprocsp/tmp
	fowners root:cprousers /var/opt/cprocsp/tmp
	fperms 770 /var/opt/cprocsp/tmp

	insinto /var/opt/cprocsp/users
	doins var/opt/cprocsp/users/global.ini
	fowners root:cprousers /var/opt/cprocsp/users
	fperms 770 /var/opt/cprocsp/users

	doman opt/cprocsp/share/man/man8/certmgr.8
	doman opt/cprocsp/share/man/man8/stunnel.8
	doman opt/cprocsp/share/man/man8/stunnel.ru.8

	if use amd64; then
		dosym ld-linux-x86-64.so.2 /$(get_libdir)/ld-lsb-x86-64.so.3
	else
		dosym ld-linux.so.2 /$(get_libdir)/ld-lsb.so.3
	fi
}

pkg_postinst() {
	cryptopro_pkg_postinst

	elog "You must be in cprousers group to use CryptoPRO products"
}
