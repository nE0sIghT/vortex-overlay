# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/yum/yum-3.4.3.ebuild,v 1.3 2012/04/02 19:54:18 pacho Exp $

EAPI="5"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="sqlite"

inherit eutils python

DESCRIPTION="Utilities for yum such as repotrack, reposync, and yumdownloader"
HOMEPAGE="http://yum.baseurl.org"
SRC_URI="http://yum.baseurl.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

DEPEND="dev-util/intltool
	test? ( dev-python/nose )"

RDEPEND="app-arch/rpm[python]
	sys-apps/yum
	dev-python/sqlitecachec
	dev-python/celementtree
	dev-libs/libxml2[python]
	dev-python/urlgrabber"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e "s:lib:$(get_libdir):g" yumutils/Makefile || die
}

src_install() {
	emake install DESTDIR="${D}"
	rm -r "${ED}etc/rc.d"
	find "${ED}" -name '*.py[co]' -print0 | xargs -0 rm -f
	python_convert_shebangs -r -x "${PYTHON_ABI}" "${ED}"
}
