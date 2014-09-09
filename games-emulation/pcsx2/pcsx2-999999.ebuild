# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit wxwidgets cmake-utils games git-r3

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="http://www.pcsx2.net"
EGIT_REPO_URI="git://github.com/PCSX2/pcsx2.git"

LICENSE="GPL-3"
SLOT="0"

IUSE="cg egl glew glsl joystick sdl sound video"
REQUIRED_USE="
    glew? ( || ( cg glsl ) )
    joystick? ( sdl )
    sound? ( sdl )
    video? ( || ( egl glew ) )
    ?? ( cg glsl )
"

LANGS="ar cs_CZ de_DE es_ES fi_FI fr_FR hr_HR hu_HU id_ID it_IT ja_JP ko_KR ms_MY nb_NO pl_PL pt_BR ru_RU sv_SE th_TH tr_TR zh_CN zh_TW"
for lang in ${LANGS}; do
        IUSE+=" linguas_${lang}"
done

RDEPEND="
	app-arch/bzip2
	dev-libs/libaio
	virtual/jpeg:62
	x11-libs/gtk+:2
	x11-libs/libICE
	x11-libs/libX11
	x11-libs/libXext
	>=sys-libs/zlib-1.2.4

	|| (
		x11-libs/wxGTK:2.8[X]
		x11-libs/wxGTK:3.0[X]
	)

	video? (
		virtual/opengl

		cg? ( media-gfx/nvidia-cg-toolkit )
		egl? ( media-libs/mesa[egl] )
		glew? ( media-libs/glew )
	)

	sdl? (
	    || (
		media-libs/libsdl[joystick?,sound?]
	    )
	)

	sound? (
		media-libs/alsa-lib
		media-libs/libsoundtouch
		media-libs/portaudio
	)
"
DEPEND="${RDEPEND}
	>=dev-cpp/sparsehash-1.5
"

PATCHES=(
	# Workaround broken glext.h, bug #510730
	"${FILESDIR}"/mesa-10.patch
)

src_prepare() {
	cmake-utils_src_prepare

	if ! use egl; then
		sed -i -e "s:GSdx TRUE:GSdx FALSE:g" cmake/SelectPcsx2Plugins.cmake || die
	fi
	if ! use glew || ! use cg; then
		sed -i -e "s:zerogs TRUE:zerogs FALSE:g" cmake/SelectPcsx2Plugins.cmake || die
	fi
	if ! use glew; then
		sed -i -e "s:zzogl TRUE:zzogl FALSE:g" cmake/SelectPcsx2Plugins.cmake || die
	fi
	if ! use joystick; then
		sed -i -e "s:onepad TRUE:onepad FALSE:g" cmake/SelectPcsx2Plugins.cmake || die
	fi
	if ! use sound; then
		sed -i -e "s:spu2-x TRUE:spu2-x FALSE:g" cmake/SelectPcsx2Plugins.cmake || die
	fi

	# Remove default CFLAGS
	sed -i -e "s:-msse -msse2 -march=i686::g" cmake/BuildParameters.cmake || die
	sed -i -e "s:-msse -msse2::g" cmake/BuildParameters.cmake || die

	einfo "Cleaning up locales..."
	for lang in ${LANGS}; do
		use "linguas_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${S}"/locales/"${lang}" || die
	done

	epatch_user
}

src_configure() {
	# pcsx2 build scripts will force CMAKE_BUILD_TYPE=Devel
	# if it something other than "Devel|Debug|Release"
	local CMAKE_BUILD_TYPE="Release"

	local WX_GTK_VER="2.8"
	if has_version 'x11-libs/wxGTK:3.0[X]'; then
		WX_GTK_VER="3.0"
	fi
	need-wxwidgets unicode

	local mycmakeargs=(
		-DEXTRA_PLUGINS=TRUE
		-DPACKAGE_MODE=TRUE
		-DXDG_STD=TRUE
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH=$(games_get_libdir)/${PN}
		-DGAMEINDEX_DIR=${GAMES_DATADIR}/${PN}
		-DGLSL_SHADER_DIR=${GAMES_DATADIR}/${PN}
		-DPLUGIN_DIR=$(games_get_libdir)/${PN}
		$(cmake-utils_use egl EGL_API)
		$(cmake-utils_use glsl GLSL_API)
	)
	if use amd64; then
		mycmakeargs+=(-D64BIT_BUILD=TRUE)
	fi

	if [ $WX_GTK_VER == '3.0' ]; then
		mycmakeargs+=(-DWX28_API=FALSE)
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install DESTDIR="${D}"

	# move binary files to correct directory
	mv ${D}/usr/bin ${D}/${GAMES_BINDIR} || die

	prepgamesdirs
}
