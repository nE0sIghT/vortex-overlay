# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

COMMIT_SHA="d43a21b9b51192e10df60c23f75e1f86b3cbc30d"
KAGUYA_COMMIT_SHA="38ca7e1d894c138e454bbe5c89048bdd5091545a"
LANGUAGES_COMMIT_SHA="6f6ac3ba603e89032d0243f5855d2818b5a00606"
LIBENDIAN_COMMIT_SHA="3911d745bbbae47b188fbdb37e8243dd695a36ba"
LIBLOBBY_COMMIT_SHA="f34149530eb3f453f3a419c6be5309ff7d232958"
LIBSIEDLER2_COMMIT_SHA="b042ad023cad5d923de45fa45c641d027a7f0d35"
LIBUTIL_COMMIT_SHA="03f0ccfe91b68d44b9c02dfc75f405fcd1923c19"
MYGETTEXT_COMMIT_SHA="0bb6c126c9f617b26b45b3044ecbc95e19f0fd6f"
S25EDIT_COMMIT_SHA="e1f9eaaa5e57c9598f37d82dc6ba6b886e45dfae"

inherit cmake desktop lua-single vcs-snapshot xdg

DESCRIPTION="Open Source remake of The Settlers II game (needs original game files)"
HOMEPAGE="http://www.siedler25.org/"
SRC_URI="
	https://github.com/Return-To-The-Roots/s25client/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/satoren/kaguya/archive/${KAGUYA_COMMIT_SHA}.tar.gz -> kaguya-${KAGUYA_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/languages/archive/${LANGUAGES_COMMIT_SHA}.tar.gz -> languages-${LANGUAGES_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/libendian/archive/${LIBENDIAN_COMMIT_SHA}.tar.gz -> libendian-${LIBENDIAN_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/liblobby/archive/${LIBLOBBY_COMMIT_SHA}.tar.gz -> liblobby-${LIBLOBBY_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/libsiedler2/archive/${LIBSIEDLER2_COMMIT_SHA}.tar.gz -> libsiedler2-${LIBSIEDLER2_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/libutil/archive/${LIBUTIL_COMMIT_SHA}.tar.gz -> libutil-${LIBUTIL_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/mygettext/archive/${MYGETTEXT_COMMIT_SHA}.tar.gz -> mygettext-${MYGETTEXT_COMMIT_SHA}.tar.gz
	https://github.com/Return-To-The-Roots/s25edit/archive/${S25EDIT_COMMIT_SHA}.tar.gz -> s25edit-${S25EDIT_COMMIT_SHA}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="${LUA_DEPS}
	app-arch/bzip2
	media-libs/libsdl[X,sound,opengl,video]
	media-libs/libsndfile
	media-libs/sdl-mixer[vorbis]
	net-libs/miniupnpc
	virtual/libiconv
	virtual/opengl
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.73:0=[nls]
	sys-devel/gettext
"

src_prepare() {
	local EXTERNAL_PACKAGES=( kaguya languages libendian liblobby libsiedler2 libutil mygettext s25edit )
	for package in ${EXTERNAL_PACKAGES[@]}; do
		local commit_variable="${package^^}_COMMIT_SHA"
		rm -r external/"${package}" || die
		ln -s ../../${package}-${!commit_variable} external/"${package}" || die
	done

	rm -r external/s25update || die

	sed -i \
		-e 's#rttr.sh noupdate#s25client#g' \
		-e 's#Terminal=true#Terminal=false#g' \
		tools/release/debian/${PN}.desktop || die

	sed -i -e '/RTTR_S2_PLACEHOLDER_PATH/d' CMakeLists.txt || die
	sed -i -e '/turtle/d' external/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DBUILD_TESTING=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_LIBRARY=$(lua_get_shared_lib)
		-DLUA_INCLUDE_DIR=$(lua_get_include_dir)
		-DRTTR_BUILD_UPDATER=OFF
		-DRTTR_DRIVERDIR="$(get_libdir)/${PN}"
		-DRTTR_ENABLE_OPTIMIZATIONS=OFF
		-DRTTR_INSTALL_PREFIX=/usr
		-DRTTR_GAMEDIR="~/.${PN}/S2"
		-DRTTR_LIBDIR="$(get_libdir)/${PN}"
		-DRTTR_USE_SYSTEM_BOOST_NOWIDE=OFF
		-DRTTR_USE_SYSTEM_LIBS=ON
		-DRTTR_VERSION="${PV}"
		-DRTTR_REVISION="${COMMIT_SHA:0:6}"
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
