# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WX_GTK_VER="2.8"

inherit wxwidgets cmake-utils games multilib

DESCRIPTION="A PlayStation 2 emulator"
HOMEPAGE="http://www.pcsx2.net"
SRC_URI="https://github.com/PCSX2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="abi_x86_32 cg debug dvd egl glew glsl iso joystick sdl sound video"
REQUIRED_USE="
    abi_x86_32
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
	!amd64? (
		app-arch/bzip2
		dev-libs/libaio
		virtual/jpeg:62
		x11-libs/gtk+:2
		x11-libs/libICE
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/wxGTK:2.8
		>=sys-libs/zlib-1.2.4

		video? (
			virtual/opengl

			cg? ( media-gfx/nvidia-cg-toolkit )
			egl? ( media-libs/mesa[egl] )
			glew? ( media-libs/glew )
		)

		sdl? ( media-libs/libsdl[joystick?,sound?] )

		sound? (
			media-libs/alsa-lib
			media-libs/libsoundtouch
			media-libs/portaudio
		)
	)
	amd64? (
		app-arch/bzip2[abi_x86_32]
		dev-libs/libaio[abi_x86_32]
		virtual/jpeg:62[abi_x86_32]
		x11-libs/gtk+:2[abi_x86_32]
		x11-libs/libICE[abi_x86_32]
		x11-libs/libX11[abi_x86_32]
		x11-libs/libXext[abi_x86_32]
		x11-libs/wxGTK:2.8[abi_x86_32]
		>=sys-libs/zlib-1.2.4[abi_x86_32]

		video? (
			virtual/opengl[abi_x86_32]

			cg? ( media-gfx/nvidia-cg-toolkit[multilib] )
			egl? ( media-libs/mesa[abi_x86_32,egl] )
			glew? ( media-libs/glew[abi_x86_32] )
		)

		sdl? ( media-libs/libsdl[abi_x86_32,joystick?,sound?] )

		sound? (
			media-libs/alsa-lib[abi_x86_32]
			media-libs/libsoundtouch[abi_x86_32]
			media-libs/portaudio[abi_x86_32]
		)
	)
"
DEPEND="${RDEPEND}
	>=dev-cpp/sparsehash-1.5
"

PATCHES=(
	# Fix Cg find for Gentoo amd64
	"${FILESDIR}"/cg-multilib.patch
	# Workaround broken glext.h, bug #510730
	"${FILESDIR}"/mesa-10.patch
)

if use debug; then
	CMAKE_BUILD_TYPE="Debug"
else
	CMAKE_BUILD_TYPE="Release"
fi

src_prepare() {
	cmake-utils_src_prepare

	! use iso && sed -i -e "s:CDVDiso TRUE:CDVDiso FALSE:g" cmake/SelectPcsx2Plugins.cmake
	! use dvd && sed -i -e "s:CDVDlinuz TRUE:CDVDlinuz FALSE:g" cmake/SelectPcsx2Plugins.cmake
	! use egl && sed -i -e "s:GSdx TRUE:GSdx FALSE:g" cmake/SelectPcsx2Plugins.cmake
	( ! use glew || ! use cg ) && sed -i -e "s:zerogs TRUE:zerogs FALSE:g" cmake/SelectPcsx2Plugins.cmake
	( ! use glew ) && sed -i -e "s:zzogl TRUE:zzogl FALSE:g" cmake/SelectPcsx2Plugins.cmake
	! use joystick && sed -i -e "s:onepad TRUE:onepad FALSE:g" cmake/SelectPcsx2Plugins.cmake
	! use sound && sed -i -e "s:spu2-x TRUE:spu2-x FALSE:g" cmake/SelectPcsx2Plugins.cmake

	# Remove default CFLAGS
	sed -i -e "s:-msse -msse2 -march=i686::g" cmake/BuildParameters.cmake

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
	use amd64 && local ABI=x86

	mycmakeargs="
		-DPACKAGE_MODE=TRUE
		-DXDG_STD=TRUE
		-DPLUGIN_DIR=$(games_get_libdir)/${PN}
		-DPLUGIN_DIR_COMPILATION=$(games_get_libdir)/${PN}
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_LIBRARY_PATH=$(games_get_libdir)/${PN}
		$(cmake-utils_use egl EGL_API)
		$(cmake-utils_use glsl GLSL_API)
	"

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install DESTDIR=${D}

	# move binary files to correct directory
	mv ${D}/usr/bin ${D}/usr/games/bin || die

	prepgamesdirs
}
