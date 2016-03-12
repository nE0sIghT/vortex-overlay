# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{3_2,3_3,3_4} )
MY_PN="devscripts"

inherit python-r1

DESCRIPTION="Scripts to make the life of a Debian Package maintainer easier"
HOMEPAGE="https://anonscm.debian.org/gitweb/?p=collab-maint/devscripts.git"
SRC_URI="mirror://debian/pool/main/d/${MY_PN}/${MY_PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl
	>=dev-lang/python-3:="

RDEPEND="${DEPEND}
	app-arch/dpkg"

IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	sed -i \
		-e 's#stylesheet/xsl/nwalsh#xsl-stylesheets#g' \
		"${S}/po4a/Makefile" \
		"${S}/scripts/Makefile" \
		"${S}/scripts/deb-reversion.dbk" || die

	sed -i \
		-e 's#--install-layout=deb##g' \
		"${S}/scripts/Makefile" || die

	rm scripts/bts.bash_completion || die
}
