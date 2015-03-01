# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker versionator

DESCRIPTION="Maps & business listings"
HOMEPAGE="http://2gis.ru"
SRC_URI="http://deb.2gis.ru/pool/non-free/2/2gis/2gis_$(get_version_component_range 1-3)-0trusty1+shv$(get_version_component_range 4)+r$(get_version_component_range 5)_amd64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RDEPEND="
	dev-libs/icu:0/52
	dev-libs/libxml2
	net-print/cups
	>=media-libs/fontconfig-2.9.0
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	virtual/opengl
	x11-base/xorg-server
"
DEPEND="${RDEPEND}
"

QA_PREBUILT="*"

DOCS=(
        usr/share/doc/2gis/changelog.Debian.gz
        usr/share/doc/2gis/copyright
)


S="${WORKDIR}"

src_install() {
	dobin usr/bin/2gis

	insinto /usr/$(get_libdir)
	doins -r usr/lib/2GIS

	insinto /usr/share
	doins -r usr/share/2GIS
	doins -r usr/share/icons

	doman usr/share/man/man1/2gis.1.gz

	domenu usr/share/applications/2gis.desktop
}
