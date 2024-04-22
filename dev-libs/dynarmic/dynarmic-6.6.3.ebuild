# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT_SHA="ba8192d89078af51ae6f97c9352e3683612cdff1"

inherit cmake vcs-snapshot

DESCRIPTION="An ARM dynamic recompiler"
HOMEPAGE="https://git.suyu.dev/suyu/dynarmic"
SRC_URI="https://git.suyu.dev/suyu/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	dev-cpp/catch:0
	dev-libs/libfmt:=
	dev-libs/xbyak
"

src_prepare() {
	cmake_src_prepare
	rm -r externals/{catch,fmt,xbyak} || die
}

src_configure() {
	local mycmakeargs=(
		-DDYNARMIC_USE_BUNDLED_EXTERNALS=OFF
		-DDYNARMIC_TESTS=$(usex test)
		-DDYNARMIC_WARNINGS_AS_ERRORS=OFF
	)
	cmake_src_configure
}
