# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils games
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/vcmi/vcmi.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="VCMI is work-in-progress attempt to recreate engine for Heroes III, giving it new and extended possibilities."
HOMEPAGE="http://vcmi.eu"

LICENSE="GPL-2"
SLOT="0"

IUSE="editor erm +launcher"

RDEPEND="
	>=dev-libs/boost-1.48
	media-libs/libsdl2
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	>=sys-devel/gcc-4.6
	sys-libs/zlib
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
"

PATCHES=(
)

src_prepare() {
	cmake-utils_src_prepare
	epatch_user
}

src_configure() {
	local mycmakeargs=(
		-DBIN_DIR=${GAMES_BINDIR#/usr/}
		-DDATA_DIR=${GAMES_DATADIR#/usr/}/${PN}
		-DLIB_DIR=${GAMES_PREFIX#/usr/}/$(get_libdir)/${PN}
		-DENABLE_PCH=OFF # Do not works with NDEBUG set
		-DENABLE_TEST=OFF
		$(cmake-utils_use_enable editor)
		$(cmake-utils_use_enable erm)
		$(cmake-utils_use_enable launcher)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install DESTDIR="${D}"
	prepgamesdirs

	dodir /etc/ld.so.conf.d/
	echo "$(games_get_libdir)/${PN}" > ${ED}/etc/ld.so.conf.d/10${PN}.conf || die

	elog "In order to play VCMI you must install:"
	elog "- Heroes III: Shadow of Death or Complete edition;"
	elog "- Unnoficial WoG addon;"
	elog "- VCMI data files."
	elog "Use vcmibuilder tool for automated install of data files;"
	elog "Additional information can be found in VCMI wiki:"
	elog "http://wiki.vcmi.eu/index.php?title=Installation_on_Linux#Installing_Heroes_III_data_files"
}
