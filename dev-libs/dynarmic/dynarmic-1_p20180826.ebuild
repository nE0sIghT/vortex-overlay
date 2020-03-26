# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT_SHA="68ca03e8d4822c78e15315e67ddbb1d6bf4d3827"

inherit cmake-utils vcs-snapshot

DESCRIPTION="An ARM dynamic recompiler"
HOMEPAGE="https://github.com/MerryMage/dynarmic"
SRC_URI="https://github.com/MerryMage/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}
	dev-cpp/catch:0
	dev-libs/libfmt:=
	dev-libs/xbyak
"

PATCHES=(
	"${FILESDIR}/dynarmic-skip-bundled-dependencies.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	rm -r externals/{catch,fmt,xbyak} || die
}

src_configure() {
	local mycmakeargs=(
		-DDYNARMIC_SKIP_EXTERNALS=ON
		-DDYNARMIC_TESTS=$(usex test)
		-DDYNARMIC_WARNINGS_AS_ERRORS=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	insinto /usr/include
	doins -r "include/${PN}"

	dolib.so "${BUILD_DIR}/src/lib${PN}.so"
}
