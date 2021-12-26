# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop

DESCRIPTION="Recreation of HoMM2 game engine"
HOMEPAGE="https://ihhub.github.io/fheroes2/"
SRC_URI="https://github.com/ihhub/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tools"

RDEPEND="
	media-libs/libpng:=
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_IMAGE=ON
		-DENABLE_TOOLS=$(usex tools)
		-DFHEROES2_STRICT_COMPILATION=OFF
		-DUSE_SYSTEM_LIBSMACKER=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	emake -C files/lang
}

src_install() {
	cmake_src_install

	doicon src/resources/"${PN}".png
	domenu script/packaging/common/"${PN}".desktop

	insinto usr/share/"${PN}"/files/lang
	doins files/lang/*.mo

	if use tools; then
		for file in 82m2wav bin2txt extractor icn2img til2img xmi2mid; do
			dobin "${BUILD_DIR}/${file}"
		done
	fi
}
