# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )
DISTUTILS_OPTIONAL=true

inherit distutils-r1

DESCRIPTION="Provides information about the Debian distributions' releases"
HOMEPAGE="https://debian.org"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}
	dev-lang/perl:=
	dev-util/distro-info-data
"

src_prepare() {
	default

	# 1. Gentoo do not provides dpkg vendor information
	# 2. Strip *FLAGS
	# 3. Strip predefined CFLAGS
	# 4. Point to correct perl's vendorlib
	sed -e "/cd python && python/d" \
		-e "/VENDOR/d" \
		-e "/dpkg-buildflags/d" \
		-e "s/-g -O2//g" \
		-e "s:\$(PREFIX)/share/perl5/Debian:\$(PERL_VENDORLIB)/Debian:g" \
		-i "${S}"/Makefile || die
}

src_configure() {
	default

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	emake PERL_VENDORLIB=$(perl -e 'require Config; print "$Config::Config{'vendorlib'}\n";') \
		DESTDIR="${D}" install

	if use python; then
		pushd "${S}"/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}
