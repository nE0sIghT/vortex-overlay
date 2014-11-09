# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-2.4.7.ebuild,v 1.1 2014/10/25 16:14:58 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"

DESCRIPTION="Test package for bug 463960"
HOMEPAGE="https://bugs.gentoo.org/show_bug.cgi?id=463960"
SRC_URI="http://coldzone.ru/upload/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	net-libs/webkit-gtk
	virtual/pkgconfig
"

src_prepare() {
	true
}

src_configure() {
	true
}

src_compile() {
	./build.sh
	./gdumpparser.py
}

src_test() {
	true
}

src_install() {
	die Test suceeded
}
