# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/citra"
LIBRETRO_COMMIT_SHA="a31aff7e1a3a66f525b9ea61633d2c5e5b0c8b31"
LODEPNG_COMMIT_SHA="31d9704fdcca0b68fb9656d4764fa0fb60e460c2"
SOUNDTOUCH_COMMIT_SHA="060181eaf273180d3a7e87349895bd0cb6ccbf4a"
TEAKRA_COMMIT_SHA="01db7cdd00aabcce559a8dddce8798dabb71949b"

inherit cmake libretro-core

DESCRIPTION="Multiplatform Sega Dreamcast emulator"
SRC_URI="
	https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/lvandeve/lodepng/archive/${LODEPNG_COMMIT_SHA}.tar.gz -> ${P}-lodepng.tar.gz
	https://github.com/rtiangha/ext-soundtouch/archive/${SOUNDTOUCH_COMMIT_SHA}.tar.gz -> ${P}-soundtouch.tar.gz
	https://github.com/wwylele/teakra/archive/${TEAKRA_COMMIT_SHA}.tar.gz -> ${P}-teakra.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/crypto++
	dev-libs/dynarmic
	dev-libs/libfmt:=
	net-libs/enet:1.3=
	app-arch/zstd:=
"
DEPEND="${RDEPEND}
	dev-cpp/catch:0
	dev-libs/xbyak
	dev-util/nihstro
"

PATCHES=(
	"${FILESDIR}/0001-externals-reduce-bundled-dependencies.patch"
	"${FILESDIR}/0002-logging-added-missing-include.patch"
	"${FILESDIR}/0003-core-fixed-dynarmic-includes.patch"
)

src_unpack() {
	default

	mv "${WORKDIR}/lodepng-${LODEPNG_COMMIT_SHA}"/* \
		"${S}/externals/lodepng/lodepng/"
	mv "${WORKDIR}/ext-soundtouch-${SOUNDTOUCH_COMMIT_SHA}"/* \
		"${S}/externals/soundtouch/"
	mv "${WORKDIR}/teakra-${TEAKRA_COMMIT_SHA}"/* \
		"${S}/externals/teakra/"
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
		-DUSE_SYSTEM_BOOST=ON
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
