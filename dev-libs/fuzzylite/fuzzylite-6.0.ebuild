# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A fuzzy logic control library in C++"
HOMEPAGE="https://fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

RDEPEND="!!<games-strategy/vcmi-0.99_p20191103"

S="${S}/${PN}"

src_prepare() {
	sed -i -e 's/-Werror//g' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static)
	)
	cmake_src_configure
}
