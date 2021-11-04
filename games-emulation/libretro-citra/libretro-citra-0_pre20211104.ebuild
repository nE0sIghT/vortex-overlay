# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/citra"
LIBRETRO_COMMIT_SHA="b1959d07a340bfd9af65ad464fd19eb6799a96ef"
SOUNDTOUCH_COMMIT_SHA="060181eaf273180d3a7e87349895bd0cb6ccbf4a"

inherit cmake libretro-core toolchain-funcs

DESCRIPTION="Multiplatform Sega Dreamcast emulator"
SRC_URI="
	https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/citra-emu/ext-soundtouch/archive/${SOUNDTOUCH_COMMIT_SHA}.tar.gz -> ${P}-soundtouch.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/crypto++
	dev-libs/dynarmic
	dev-libs/libfmt
	net-libs/enet:1.3=
"
DEPEND="${RDEPEND}
	dev-cpp/catch:0
	dev-libs/xbyak
	dev-util/nihstro
"

PATCHES=(
	"${FILESDIR}/0001-externals-reduce-bundled-dependencies.patch"
)

src_unpack() {
	default

	mv "${WORKDIR}/ext-soundtouch-${SOUNDTOUCH_COMMIT_SHA}"/* \
		"${S}/externals/soundtouch/"
}

src_prepare() {
	cmake_src_prepare
	sed -i '/check_submodules_present()/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_BUNDLED_DEPENDENCIES=ON
		-DENABLE_LIBRETRO=ON
		-DENABLE_QT=OFF
		-DENABLE_SDL2=OFF
		-DENABLE_WEB_SERVICE=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}/src/citra_libretro/${LIBRETRO_CORE_NAME}_libretro.so" \
                libretro-core_src_install
}
