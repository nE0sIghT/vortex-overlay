# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT_SHA="8db1ea0d143637fc7ef0647f989850329fc0a295"
KAGUYA_COMMIT_SHA="38ca7e1d894c138e454bbe5c89048bdd5091545a"
LANGUAGES_COMMIT_SHA="b1978170473bbf39a24254814e1b1f967a51ef4c"
LIBENDIAN_COMMIT_SHA="dd2c11498f679247530b6b7cf7bd5964f539ddfd"
LIBLOBBY_COMMIT_SHA="7d85ec40f03af619a6734f20edb28d991b3d61f2"
LIBSIEDLER2_COMMIT_SHA="fcccb9327577edcb08f562728504d0cf7a09895b"
LIBUTIL_COMMIT_SHA="f47edf58a89aecec9438b65b47347629f9b02afd"
MYGETTEXT_COMMIT_SHA="7e46bbb3e24891348f5629887efb0173690e83b8"
S25EDIT_COMMIT_SHA="213729b770dc99b8f6878f6c57dcc2ffc4831f3e"

inherit cmake-utils desktop vcs-snapshot xdg

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

RDEPEND="app-arch/bzip2
	dev-lang/lua:5.2
	media-libs/libsdl[X,sound,opengl,video]
	media-libs/libsndfile
	media-libs/sdl-mixer[vorbis]
	net-libs/miniupnpc
	virtual/libiconv
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-libs/boost:0=[nls]
	sys-devel/gettext
"

PATCHES=(
	"${FILESDIR}"/"${PN}-0.9.0_pre20191013"-package-mode.patch
)

src_prepare() {
	local EXTERNAL_PACKAGES=( kaguya languages libendian liblobby libsiedler2 libutil mygettext s25edit )
	for package in ${EXTERNAL_PACKAGES[@]}; do
		local commit_variable="${package^^}_COMMIT_SHA"
		rm -r external/"${package}" || die
		ln -s ../../${package}-${!commit_variable} external/"${package}" || die
	done

	rm -r external/{lua,macos,s25update} || die

	pushd "${WORKDIR}"/libutil-"${LIBUTIL_COMMIT_SHA}" > /dev/null || die
	eapply "${FILESDIR}"/"${PN}"-0.9.0_pre20190919-disable-warnings.patch
	pushd > /dev/null || die

	sed -i \
		-e 's#rttr.sh noupdate#s25client#g' \
		-e 's#Terminal=true#Terminal=false#g' \
		tools/release/debian/${PN}.desktop || die

	sed -i -e '/RTTR_S2_PLACEHOLDER_PATH/d' CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE="Release"
	local mycmakeargs=(
		-DPACKAGE_MODE=ON
		-DBUILD_TESTING=OFF
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_SKIP_RPATH=ON
		-DRTTR_BUILD_UPDATER=OFF
		-DRTTR_ENABLE_OPTIMIZATIONS=OFF
		-DRTTR_INSTALL_PREFIX=/usr
		-DRTTR_DRIVERDIR="$(get_libdir)/${PN}"
		-DRTTR_GAMEDIR="~/.${PN}/S2"
		-DRTTR_LIBDIR="$(get_libdir)/${PN}"
		-DRTTR_VERSION="${PV}"
		-DRTTR_REVISION="${COMMIT_SHA:0:6}"
		-DUSE_SDL2=OFF
		-DRTTR_USE_SYSTEM_SAMPLERATE=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	doicon tools/release/debian/${PN}.png
	domenu tools/release/debian/${PN}.desktop
}

pkg_postinst() {
	elog "Copy your Settlers2 game files into ~/.${PN}/S2"
	xdg_pkg_postinst
}
