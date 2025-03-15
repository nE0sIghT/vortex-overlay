# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT_SHA="b79897f598c16b6a1a18e5f512a6be4ed8ed5812"
INNOEXTRACT_SHA="9977089412ebafe9f79936aa65a2edf16a84ae3e"
LUA_COMPAT=(luajit)

inherit cmake lua-single vcs-snapshot xdg

DESCRIPTION="VCMI is work-in-progress attempt to recreate engine for Heroes III."
HOMEPAGE="http://vcmi.eu"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/vcmi/innoextract/archive/${INNOEXTRACT_SHA}.tar.gz -> ${PN}-innoextract-${PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="editor +launcher"

REQUIRED_USE="${LUA_REQUIRED_USE}"
RDEPEND="
	${LUA_DEPS}
	dev-cpp/tbb
	dev-libs/fuzzylite:=
	media-libs/libsdl2:=[video]
	media-libs/sdl2-image:=
	media-libs/sdl2-mixer:=
	media-libs/sdl2-ttf:=
	media-video/ffmpeg:=
	sys-libs/zlib[minizip]

	editor? (
		dev-qt/qtwidgets:5
		dev-qt/linguist-tools
	)
	launcher? (
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		dev-qt/linguist-tools
	)
"
DEPEND="${RDEPEND}
	dev-libs/boost:=[nls]
	virtual/pkgconfig
"

src_unpack() {
	vcs-snapshot_src_unpack

	rmdir "${S}/launcher/lib/innoextract"
	mv "${WORKDIR}/${PN}-innoextract-${PV}" "${S}/launcher/lib/innoextract"
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_EDITOR=$(usex editor)
		-DENABLE_ERM=ON
		-DENABLE_GITVERSION=OFF
		-DENABLE_LAUNCHER=$(usex launcher)
		-DENABLE_LUA=ON
		-DENABLE_NULLKILLER_AI=ON
		-DENABLE_PCH=ON
		-DENABLE_TEST=OFF
		-DENABLE_TRANSLATIONS=ON

		-DFORCE_BUNDLED_FL=OFF
		-DFORCE_BUNDLED_MINIZIP=OFF
		-DENABLE_GITVERSION=OFF
		-DBoost_NO_BOOST_CMAKE=ON
	)

	cmake_src_configure
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
