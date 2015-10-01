# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

MY_P="TouchControl-for-Android"

DESCRIPTION="Software to control your android device over adb"
HOMEPAGE="https://github.com/ternes3/TouchControl-for-Android"
SRC_URI="https://github.com/ternes3/${MY_P}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-libs/boost
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
RDEPEND="${DEPEND}

	dev-java/droid-at-screen
	dev-util/android-tools
	virtual/jre
"

S="${WORKDIR}/${MY_P}-${PV}"

src_prepare() {
	default

	epatch "${FILESDIR}/${P}-contrib.patch"
}

src_configure() {
	eqmake4
}

src_install() {
	default

	dobin ${PN}
}
