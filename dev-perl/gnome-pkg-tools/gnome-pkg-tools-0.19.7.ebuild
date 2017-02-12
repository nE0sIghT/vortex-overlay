# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit perl-functions

DESCRIPTION="Useful tools for the Debian GNOME Packaging Team"
HOMEPAGE="https://www.debian.org/"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl:="
RDEPEND="
	${DEPEND}
	dev-util/debhelper
"

src_install() {
	perl_set_version

	insinto "${VENDOR_LIB}"/Debian/Debhelper/Sequence
	doins dh/gnome.pm

	insinto /usr/share/"${PN}"
	doins -r 1
	doins control.header
	doins pkg-gnome.team

	dobin desktop-check-mime-types
	dobin dh/dh_gnome
	dobin dh/dh_gnome_clean
}
