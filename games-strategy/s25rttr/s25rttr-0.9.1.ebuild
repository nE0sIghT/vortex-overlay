# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..3} )

inherit cmake desktop lua-single xdg

MY_PN="s25client"
DESCRIPTION="Open Source remake of The Settlers II game (needs original game files)"
HOMEPAGE="https://www.siedler25.org/"
SRC_URI="https://github.com/Return-To-The-Roots/${MY_PN}/releases/download/v${PV}/${MY_PN}_src_v${PV}.tar.gz"
LICENSE="GPL-2+ GPL-3 Boost-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}
	app-arch/bzip2
	>=dev-libs/boost-1.73:0=[nls]
	>=media-libs/libsamplerate-0.1.9
	>=media-libs/libsdl2-2.0.10-r2[opengl,sound,video]
	media-libs/libsndfile
	media-libs/sdl2-mixer[vorbis,wav]
	net-libs/miniupnpc
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.0_pre20200723-boost-1.77-missing-include.patch
	"${FILESDIR}"/${PN}-0.9.1-libsamplerate.patch
	"${FILESDIR}"/${PN}-0.9.1-cxx-std.patch
)

S="${WORKDIR}/${MY_PN}_v${PV}"

src_prepare() {
	rm -r external/s25update external/{kaguya,libutil}/cmake/FindLua.cmake || die

	sed -i \
		-e 's#rttr.sh noupdate#s25client#g' \
		-e 's#Terminal=true#Terminal=false#g' \
		tools/release/debian/${PN}.desktop || die

	sed -i -e '/RTTR_S2_PLACEHOLDER_PATH/d' CMakeLists.txt || die
	sed -i -e '/turtle/d' external/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	if [[ -f revision.txt ]]; then
		local RTTR_REVISION="$(< revision.txt)"
	elif [[ -n ${COMMIT} ]]; then
		local RTTR_REVISION="${COMMIT}"
	else
		die "Could not determine RTTR_REVISION."
	fi

	local CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DCCACHE_PROGRAM=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_DISABLE_FIND_PACKAGE_ClangFormat=ON
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_LIBRARY=$(lua_get_shared_lib)
		-DLUA_INCLUDE_DIR=$(lua_get_include_dir)
		-DRTTR_BUILD_UPDATER=OFF
		-DRTTR_DRIVERDIR="$(get_libdir)/${PN}"
		-DRTTR_ENABLE_OPTIMIZATIONS=OFF
		-DRTTR_ENABLE_WERROR=OFF
		-DRTTR_INCLUDE_DEVTOOLS=OFF
		-DRTTR_INSTALL_PREFIX=/usr
		-DRTTR_GAMEDIR="~/.${PN}/S2"
		-DRTTR_LIBDIR="$(get_libdir)/${PN}"
		-DRTTR_USE_SYSTEM_BOOST_NOWIDE=OFF
		-DRTTR_USE_SYSTEM_LIBS=ON
		-DRTTR_VERSION="${PV##*_pre}"
		-DRTTR_REVISION="${RTTR_REVISION}"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	doicon tools/release/debian/${PN}.png
	domenu tools/release/debian/${PN}.desktop
}

pkg_postinst() {
	elog "Copy your Settlers2 game files into ~/.${PN}/S2"
	xdg_pkg_postinst
}
