# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2

DESCRIPTION="APIs for talking with Dalvik VM"
HOMEPAGE="http://tools.android.com/"
SRC_URI="http://central.maven.org/maven2/com/google/android/tools/${PN}/r${PV}/${PN}-r${PV}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=virtual/jre-1.5
"

S="${WORKDIR}"

src_unpack() { :; }

src_install() {
	java-pkg_newjar "${DISTDIR}/${PN}-r${PV}.jar"
}
