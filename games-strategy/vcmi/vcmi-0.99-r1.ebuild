# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils xdg

DESCRIPTION="VCMI is work-in-progress attempt to recreate engine for Heroes III."
HOMEPAGE="http://vcmi.eu"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="editor erm +launcher"

RDEPEND="
	media-libs/libsdl2[video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	sys-libs/zlib[minizip]
	virtual/ffmpeg

	editor? (
		dev-qt/qtwidgets:5
	)
	launcher? (
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	dev-libs/boost[nls]
	virtual/pkgconfig
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_PCH=OFF # Do not works with NDEBUG set
		-DENABLE_TEST=OFF
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_ERM=$(usex erm)
		-DENABLE_LAUNCHER=$(usex launcher)
	)

	cmake-utils_src_configure
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
