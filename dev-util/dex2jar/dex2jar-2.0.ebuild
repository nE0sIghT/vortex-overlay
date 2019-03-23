# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"

DESCRIPTION="Tools to work with android .dex and java .class files"
HOMEPAGE="https://github.com/pxb1988/dex2jar"
SRC_URI="https://github.com/pxb1988/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="|| ( virtual/jre virtual/jdk )"

src_prepare() {
	rm *.bat
	chmod a+x *.sh
	rm *.txt

	cd lib
	mv dx-NOTICE dx-NOTICE.txt
	rm *.txt
}

src_install() {
	dodir /opt/"${PN}"
	cp -R "${S}"/* "${D}/opt/"${PN}"" || die "Install failed!"

	dosym /opt/dex2jar/dex2jar.sh /usr/bin/dex2jar
}
