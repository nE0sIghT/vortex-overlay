# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 java-pkg-2 java-pkg-simple

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
}

src_compile() {
	mkdir -p target/classes/META-INF || die
	# Ugly. Rewrite
	echo Class-Path: /usr/share/log4j/lib/log4j.jar /usr/share/ddmlib/lib/ddmlib.jar > target/classes/META-INF/MANIFEST.MF
	cat src/main/etc/META-INF/MANIFEST.MF >> target/classes/META-INF/MANIFEST.MF || die

	cp -r src/main/resources/* target/classes/ || die

	java-pkg-simple_src_compile
}
