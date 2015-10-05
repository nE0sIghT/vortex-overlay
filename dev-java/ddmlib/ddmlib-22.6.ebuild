# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="APIs for talking with Dalvik VM"
HOMEPAGE="http://tools.android.com/"
SRC_URI="https://android.googlesource.com/platform/tools/base/+archive/tools_r${PV}/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-java/guava:13
	dev-java/kxml:2
	dev-java/xpp3:0
	=dev-java/support-annotations-"${PV}:0"
"
RDEPEND="${DEPEND}
	>=virtual/jre-1.5
"

S="${WORKDIR}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="guava-13,kxml-2,xpp3,support-annotations"
