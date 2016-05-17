# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{3,4,5} )
DISTUTILS_OPTIONAL=true

inherit distutils-r1

DESCRIPTION="Scripts to make the life of a Debian Package maintainer easier"
HOMEPAGE="https://anonscm.debian.org/gitweb/?p=collab-maint/devscripts.git"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python test"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-lang/perl
	python? ( ${PYTHON_DEPS} )
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-util/distro-info
		dev-util/shunit2
	)
"
RDEPEND="${DEPEND}
	app-arch/dpkg
	app-text/wdiff
	dev-util/debhelper
	sys-apps/fakeroot
"

DISTUTILS_S="${S}"/scripts

src_prepare() {
	default

	# Replace Debian xsl stylesheets paths with Gentoo's
	sed -i \
		-e 's#stylesheet/xsl/nwalsh#xsl-stylesheets#g' \
		"${S}"/po4a/Makefile \
		"${DISTUTILS_S}"/Makefile \
		"${DISTUTILS_S}"/deb-reversion.dbk || die

	# distutils-r1 eclass will be used instead
	sed -i -e "/python3 setup.py/d" \
		-e "/python3 -m flake8/d" \
		-e "/py3versions/d" \
		"${DISTUTILS_S}"/Makefile || die

	# Avoid file collision with app-shells/bash-completion
	rm "${DISTUTILS_S}"/bts.bash_completion || die

	# It's not possible to use all Debian stuff in Gentoo.
	# Remove known failing tests for now.
	sed -i -e "s/dd-list//g" \
		-e "s/package_lifecycle//g" \
		"${S}"/test/Makefile || die
}

src_configure() {
	default

	if use python; then
		pushd "${DISTUTILS_S}" > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		pushd "${DISTUTILS_S}" > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	dodir /usr/bin
	default

	if use python ;then
		pushd "${DISTUTILS_S}" > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}

src_test() {
	default

	if use python; then
		pushd "${DISTUTILS_S}" > /dev/null || die
		distutils-r1_src_test
		popd > /dev/null || die
	fi
}
