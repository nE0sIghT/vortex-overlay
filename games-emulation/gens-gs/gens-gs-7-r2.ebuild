# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils autotools flag-o-matic games

MY_PV="r${PV}"

DESCRIPTION="A Gens fork which aims to clean up the source code and combine features from other forks"
HOMEPAGE="http://info.sonicretro.org/Gens/GS"
SRC_URI="http://www.soniccenter.org/gerbilsoft/gens/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug opengl"

RDEPEND="opengl? ( virtual/opengl )
	>=media-libs/libsdl-1.2[opengl?]
	x11-libs/gtk+:2
	virtual/libiconv
	!games-emulation/gens
	amd64? ( app-emulation/emul-linux-x86-sdl
	app-emulation/emul-linux-x86-gtklibs )"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98"

S="${WORKDIR}/${PN}-r${PV}"

src_prepare() {
	epatch "${FILESDIR}/gtk_build_fix.patch"
	epatch "${FILESDIR}/amd64.patch"
	epatch "${FILESDIR}/libtool.patch"
	sed -i '1i#define OF(x) x' src/extlib/minizip/ioapi.h
	eautoreconf

	append-ldflags -Wl,-z,noexecstack
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86
	egamesconf \
		$(use_with opengl) \
		$(use_enable debug) \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS.txt ChangeLog.txt NEWS.txt README.txt
	prepgamesdirs
	make_desktop_entry "${PN}" "Gens/GS" "/usr/share/games/gens/gensgs_48x48.png" "Game;"
}
