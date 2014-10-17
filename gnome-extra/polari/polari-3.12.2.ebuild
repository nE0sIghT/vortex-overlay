# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-3.12.2.ebuild,v 1.3 2014/07/23 15:17:29 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit eutils gnome2

DESCRIPTION="Internet Relay Chat (IRC) client designed for GNOME 3"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2+ LGPL-2+ FDL-1.1"
SLOT="0"

# profiling?
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/gjs
	net-libs/telepathy-glib
	net-irc/telepathy-idle
	>=x11-libs/gtk+-3.11.5[introspection]
"
DEPEND="
	dev-util/desktop-file-utils
	virtual/pkgconfig
"

src_prepare() {
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure
}

src_install() {
	gnome2_src_install
}

pkg_postinst() {
	gnome2_pkg_postinst
}
