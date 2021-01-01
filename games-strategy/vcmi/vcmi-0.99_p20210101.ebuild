# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT_SHA="f31c5169b5814336acce04e8912b6632d22555c0"

inherit cmake vcs-snapshot xdg

DESCRIPTION="VCMI is work-in-progress attempt to recreate engine for Heroes III."
HOMEPAGE="http://vcmi.eu"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="editor erm +launcher"

RDEPEND="
	dev-libs/fuzzylite
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	media-video/ffmpeg
	sys-libs/zlib[minizip]

	editor? (
		dev-qt/qtwidgets:5
	)
	launcher? (
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	dev-libs/boost:=[nls]
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_ERM=$(usex erm)
		-DENABLE_GITVERSION=OFF
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_PCH=ON
		-DENABLE_TEST=OFF
		-DFORCE_BUNDLED_FL=OFF
	)

	cmake_src_configure
	touch "${BUILD_DIR}/Version.cpp" || die
}

src_install() {
	cmake_src_install
	mv "${D}"/usr/$(get_libdir)/${PN}/lib${PN}.so \
		"${D}"/usr/$(get_libdir) || die
}

pkg_postinst() {
	xdg_pkg_postinst

	elog "In order to play VCMI you must install:"
	elog "- Heroes III: Shadow of Death or Complete edition;"
	elog "- Unnoficial WoG addon;"
	elog "- VCMI data files."
	elog "Use vcmibuilder tool for automated install of data files;"
	elog "Additional information can be found in VCMI wiki:"
	elog "http://wiki.vcmi.eu/index.php?title=Installation_on_Linux#Installing_Heroes_III_data_files"
}
