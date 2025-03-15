# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT_SHA="d707afea8a363a0ae60d5c38ddf73d73e2ea0cb3"

inherit cmake vcs-snapshot

DESCRIPTION="A fuzzy logic control library in C++"
HOMEPAGE="https://fuzzylite.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static test"

DEPEND="
	test? ( dev-cpp/catch )
"

src_prepare() {
	sed -i -e 's/-Werror//g' CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DFL_BUILD_STATIC=$(usex static)
		-DFL_BUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
