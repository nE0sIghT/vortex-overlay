# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: The comments in this file are for instruction and documentation.
# They're not meant to appear with your final, production ebuild.  Please
# remember to remove them before submitting or committing your ebuild.  That
# doesn't mean you can't add your own comments though.

# The EAPI variable tells the ebuild format in use.
# It is suggested that you use the latest EAPI approved by the Council.
# The PMS contains specifications for all EAPIs. Eclasses will test for this
# variable if they need to use features that are not universal in all EAPIs.
# If an eclass doesn't support latest EAPI, use the previous EAPI instead.
EAPI=8
PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 systemd

DESCRIPTION="systemd-resolved and docker DNS integration"
HOMEPAGE="https://copr.fedorainfracloud.org/coprs/flaktack/systemd-resolved-docker/"
SRC_URI="https://github.com/flaktack/${PN}/archive/refs/tags/${PN}-${PV}-1.tar.gz"
S="${WORKDIR}/${PN}-${P}-1"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/dnslib
	dev-python/docker
	dev-python/pyroute2
	dev-python/python-systemd
"

src_install() {
	distutils-r1_src_install
	systemd_dounit "${PN}.service"
	insinto /etc/sysconfig
	newins "${PN}.sysconfig" "${PN}"
}
