# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} pypy3 )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Simple library to encode/decode DNS wire-format packets"
HOMEPAGE="https://pypi.org/project/dnslib/"
SRC_URI="https://github.com/paulc/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="${RDEPEND}"

python_test() {
	./run_tests.sh || die
}
