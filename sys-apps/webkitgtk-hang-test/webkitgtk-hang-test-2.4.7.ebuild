# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/webkit-gtk/webkit-gtk-2.4.7.ebuild,v 1.1 2014/10/25 16:14:58 pacho Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit flag-o-matic gnome2 pax-utils python-any-r1

DESCRIPTION="Test pachage for bug 463960"
HOMEPAGE="https://bugs.gentoo.org/show_bug.cgi?id=463960"
SRC_URI="http://coldzone.ru/${P}.tar.gz"

LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	net-libs/webkit-gtk
"

src_prepare() {
	sed -i -e "s:net-libs/webkit-gtk-2.4.7/work/webkitgtk-2.4.7:sys-apps/webkitgtk-hang-test-2.4.7/work/webkitgtk-hang-test-2.4.7:g" libwebkit2gtk-3.0.la
	sed -i -e "s:net-libs/webkit-gtk-2.4.7/work/webkitgtk-2.4.7:sys-apps/webkitgtk-hang-test-2.4.7/work/webkitgtk-hang-test-2.4.7:g" libwebkitgtk-3.0.la
	sed -i -e "s:net-libs/webkit-gtk-2.4.7/work/webkitgtk-2.4.7:sys-apps/webkitgtk-hang-test-2.4.7/work/webkitgtk-hang-test-2.4.7:g" tmp-introspectNQNGst/WebKit-3.0
}

src_configure() {
	true
}

src_compile() {
	gnome2_src_compile
}

src_test() {
	true
}

src_install() {
	die Test suceeded
}
