# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/corsix-th/corsix-th-0.21-r1.ebuild,v 1.2 2013/07/28 21:02:57 miknix Exp $

EAPI=5

inherit eutils cmake-utils games git-2

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="http://code.google.com/p/corsix-th/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/CorsixTH/CorsixTH.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg truetype opengl +sdl +sound +midi luajit"
REQUIRED_USE="|| ( sdl opengl )"

RDEPEND=">=dev-lang/lua-5.1
	media-libs/libsdl[X]
	ffmpeg? ( virtual/ffmpeg )
	truetype? ( media-libs/freetype:2 )
	opengl? ( virtual/opengl )
	sound? ( media-libs/sdl-mixer )
	midi? ( media-libs/sdl-mixer[timidity] )
	luajit? ( dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/CorsixTH-${PV}"

src_prepare() {
	epatch "${FILESDIR}/${P}-nodoc.patch"

	# Use a coherent naming for installation dir
	epatch "${FILESDIR}/${PN}-0.30-naming.patch"
}

src_configure() {
	local mycmakeargs="$(cmake-utils_use_with opengl OPENGL) \
		$(cmake-utils_use_with sdl SDL) \
		$(cmake-utils_use_with sound AUDIO) \
		$(cmake-utils_use_with truetype FREETYPE2) \
		$(cmake-utils_use_with ffmpeg MOVIES) \
		$(cmake-utils_use_with luajit LUAJIT) \
		-DCMAKE_INSTALL_PREFIX=${GAMES_DATADIR}"
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	DOCS="README.txt CorsixTH/changelog.txt" cmake-utils_src_install
	games_make_wrapper ${PN} "${GAMES_DATADIR}/${PN}/CorsixTH" || die
	make_desktop_entry ${PN} ${PN} \
		"${GAMES_DATADIR}/${PN}/CorsixTH.ico"
	prepgamesdirs
}
