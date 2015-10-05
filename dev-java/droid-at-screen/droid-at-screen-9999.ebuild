# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MY_NAME="Droid@Screen"

inherit eutils git-r3 java-pkg-2 java-pkg-simple

DESCRIPTION="Java program that show the device screen of an Android phone at a computer"
HOMEPAGE="http://droid-at-screen.org"
#SRC_URI="ftp://foo.example.org/${P}.tar.gz"
EGIT_REPO_URI="https://github.com/ribomation/DroidAtScreen1.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
	dev-java/ddmlib:0
	dev-java/log4j:0
"

RDEPEND="${COMMON_DEPEND}

	>=virtual/jre-1.6
"
DEPEND="${COMMON_DEPEND}

	>=virtual/jdk-1.6
"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="ddmlib,log4j"

java_prepare() {
	# Easier to use java-pkg-simple.
	rm -v pom.xml || die

	# Filter properties
	sed \
		-e "s/\${project.name}/${MY_NAME}/g" \
		-e "s/\${project.version}/${PV}/g" \
		-i src/main/resources/app.properties || die
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	insinto /etc/"${PN}"
	doins src/main/resources/*.properties
	rm src/main/resources/*.properties || die

	insinto /usr/share/"${PN}"
	doins -r target/classes/
	doins -r src/main/resources/

	dobin "${FILESDIR}"/${PN}
	make_desktop_entry "${PN}" "${MY_NAME}"
}
