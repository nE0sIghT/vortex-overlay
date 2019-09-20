# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT_SHA="be5efd44f446e415d99aafaa0b35ab2c63207403"
KAGUYA_COMMIT_SHA="38ca7e1d894c138e454bbe5c89048bdd5091545a"
LANGUAGES_COMMIT_SHA="b1978170473bbf39a24254814e1b1f967a51ef4c"
LIBENDIAN_COMMIT_SHA="0454261d3ed1a3d8c4ce6cb019d87f53fd5b66e0"
LIBLOBBY_COMMIT_SHA="a0348e771b785704982ff41f04e8c7e85b01ebe6"
LIBSIEDLER2_COMMIT_SHA="5aac2d833a8f30935332f535a49ee513a2b27b19"
LIBUTIL_COMMIT_SHA="9b9ce7c1fa170478a02dbe733fe834a9fb8ef0f2"
MYGETTEXT_COMMIT_SHA="19e8cdd32f2d2fc89bdafa69f4da788d448f8429"
S25EDIT_COMMIT_SHA="b7728d14ddc5a279697ecb9d42babd006f2a8ed4"

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
	media-libs/libsamplerate
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
	"${FILESDIR}"/"${P}"-package-mode.patch
)

src_prepare() {
	local EXTERNAL_PACKAGES=( kaguya languages libendian liblobby libsiedler2 libutil mygettext s25edit )
	for package in ${EXTERNAL_PACKAGES[@]}; do
		local commit_variable="${package^^}_COMMIT_SHA"
		rm -r external/"${package}" || die
		ln -s ../../${package}-${!commit_variable} external/"${package}" || die
	done

	rm -r external/{libsamplerate,lua,macos,s25update} || die

	pushd "${WORKDIR}"/libutil-"${LIBUTIL_COMMIT_SHA}" > /dev/null || die
	eapply "${FILESDIR}"/${P}-disable-warnings.patch
	pushd > /dev/null || die

	sed -i \
		-e 's#rttr.sh noupdate#s25client#g' \
		-e 's#Terminal=true#Terminal=false#g' \
		tools/release/debian/${PN}.desktop || die

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
