# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 systemd

DESCRIPTION="CLI tool to automatically reconnect buggy trusted bluetooth devices."
HOMEPAGE="https://github.com/nE0sIghT/bluetooth-buggy-reconnect"
SRC_URI="https://github.com/nE0sIghT/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	')
"

src_install() {
	distutils-r1_src_install
	systemd_dounit "${PN}.service"
}
