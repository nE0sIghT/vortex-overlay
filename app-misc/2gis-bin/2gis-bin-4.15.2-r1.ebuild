# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker versionator

DESCRIPTION="Maps & business listings"
HOMEPAGE="http://2gis.ru"
SRC_URI="
	amd64? ( http://deb.2gis.ru/pool/non-free/2/2gis/2gis_${PV}-0trusty1+shv280+r339_amd64.deb )
	x86? ( http://deb.2gis.ru/pool/non-free/2/2gis/2gis_${PV}-0trusty1+shv280+r15_i386.deb )
"

LICENSE="freedist"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/opengl
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXdmcp
	x11-libs/libXi
	x11-libs/libXrender
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
