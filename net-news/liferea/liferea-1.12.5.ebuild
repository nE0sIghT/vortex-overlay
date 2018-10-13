# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit gnome2 python-single-r1

MY_P=${P/_/-}a

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo feeds"
HOMEPAGE="https://lzone.de/liferea/"
SRC_URI="https://github.com/lwindolf/${PN}/releases/download/v${PV/_/-}/${MY_P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-crypt/libsecret[introspection]
	>=dev-db/sqlite-3.7.0:3
	>=dev-libs/glib-2.28.0:2
	dev-libs/gobject-introspection
	dev-libs/json-glib
	>=dev-libs/libpeas-1.0.0[gtk,python,${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.6.27:2
	>=dev-libs/libxslt-1.1.19
	gnome-base/gsettings-desktop-schemas
	>=net-libs/libsoup-2.42:2.4
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
	>=x11-libs/pango-1.4.0"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}"/${MY_P}

pkg_postinst() {
	elog "If you want to enhance the functionality of this package,"
	elog "you should consider installing:"
	elog "    net-misc/networkmanager"
}
