# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/s25rttr/s25rttr-0.8.1.ebuild,v 1.1 2013/12/23 13:45:08 hasufell Exp $

EAPI=6
inherit eutils cmake-utils gnome2-utils git-r3

DESCRIPTION="Open Source remake of The Settlers II game (needs original game files)"
HOMEPAGE="http://www.siedler25.org/"

EGIT_REPO_URI="https://github.com/Return-To-The-Roots/s25client.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="glfw"

RDEPEND="app-arch/bzip2
	dev-lang/lua:5.2
	media-libs/libsamplerate
	media-libs/libsdl[X,sound,opengl,video]
	media-libs/libsndfile
	media-libs/sdl-mixer[vorbis]
	net-libs/miniupnpc
	virtual/libiconv
	virtual/opengl
	glfw? ( <media-libs/glfw-3 )"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.56.0:0=
	sys-devel/gettext"

PATCHES=(
        "${FILESDIR}"/${P}-cmake.patch
)

src_prepare() {
	# Ensure no bundled libraries are used
	for file in $(ls ${S}/contrib/); do
		# Preserve boost backports and kaguya
		if [ "${file}" != "backport" -a "${file}" != "kaguya" ]; then
			rm -r contrib/"${file}" || die
		fi
	done

	# Prevent installation of git stuff
	rm -r RTTR/languages/.git/ || die
	rm RTTR/languages/.gitignore || die

	cmake-utils_src_prepare
}

src_configure() {
	local arch
	case ${ARCH} in
		amd64)
			arch="x86_64" ;;
		x86)
			arch="i386" ;;
		*) die "Architecture ${ARCH} not yet supported" ;;
	esac

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DENABLE_OPTIMIZATIONS=OFF
		-DRTTR_INSTALL_PREFIX=/usr
		-DRTTR_DRIVERDIR="$(get_libdir)/${PN}"
		-DRTTR_GAMEDIR="~/.${PN}/S2"
		-DRTTR_LIBDIR="$(get_libdir)/${PN}"
		-DCOMPILEFOR="linux"
		-DCOMPILEARCH="${arch}"
		-DCMAKE_SKIP_RPATH=YES
		-DBUILD_GLFW="$(usex glfw)"
	)

	cmake-utils_src_configure
}

src_compile() {
	# work around some relative paths (CMAKE_IN_SOURCE_BUILD not supported)
	ln -s "${CMAKE_USE_DIR}"/RTTR "${CMAKE_BUILD_DIR}"/RTTR || die

	cmake-utils_src_compile
}

src_install() {
	cd "${CMAKE_BUILD_DIR}" || die

	exeinto /usr/"$(get_libdir)"/${PN}
	doexe s-c/src/sound-convert s-c/resample-1.8.1/src/s-c_resample
	exeinto /usr/"$(get_libdir)"/${PN}/video
	doexe driver/video/SDL/src/libvideoSDL.so
	use glfw && doexe driver/video/GLFW/src/libvideoGLFW.so
	exeinto /usr/"$(get_libdir)"/${PN}/audio
	doexe driver/audio/SDL/src/libaudioSDL.so

	insinto /usr/share/"${PN}"
	doins -r "${CMAKE_USE_DIR}"/RTTR

	doicon -s 64 "${CMAKE_USE_DIR}"/debian/${PN}.png
	dobin src/s25client
	make_desktop_entry "s25client" "Settlers RTTR" "${PN}" "Game;StrategyGame" "Path=/usr/bin"
	dodoc RTTR/texte/{keyboardlayout.txt,readme.txt}
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "Copy your Settlers2 game files into ~/.${PN}/S2"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
