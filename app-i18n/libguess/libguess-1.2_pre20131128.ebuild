# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/libguess/libguess-1.1.ebuild,v 1.11 2014/01/26 13:45:12 hattya Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="A high-speed character set detection library."
HOMEPAGE="http://www.atheme.org/project/libguess"
SRC_URI="http://distfiles.atheme.org/${PN}-1.1.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	dev-libs/libmowgli:2"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-1.1

src_prepare() {
	epatch "${FILESDIR}"/libguess-1.2-cc43cefca5.patch
	epatch_user

	eautoreconf
}

src_configure() {
	econf $(use_enable examples) || die "econf failed"
}

src_test() {
	cd src/tests
	emake || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
