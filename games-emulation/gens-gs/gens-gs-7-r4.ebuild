# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils flag-o-matic games

MY_PV="r${PV}"

DESCRIPTION="A Gens fork which aims to clean up the source code and combine features from other forks"
HOMEPAGE="http://info.sonicretro.org/Gens/GS"
SRC_URI="http://www.soniccenter.org/gerbilsoft/gens/${MY_PV}/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="opengl"

RDEPEND="opengl? (
		virtual/opengl[abi_x86_32]
	)

	>=media-libs/libsdl-1.2[opengl?,abi_x86_32]
	x11-libs/gtk+:2[abi_x86_32]

	!games-emulation/gens
"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-0.98
"

S="${WORKDIR}/${PN}-r${PV}"

PATCHES=(
	"${FILESDIR}/gtk_build_fix.patch"
	"${FILESDIR}/amd64.patch"
	"${FILESDIR}/libtool.patch"
)
DOCS=( "ChangeLog.txt" )

src_prepare() {
	base_src_prepare

	sed -i '1i#define OF(x) x' src/extlib/minizip/ioapi.h

	append-ldflags -Wl,-z,noexecstack
	eautoreconf
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86

	egamesconf \
		$(use_with opengl) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	einstalldocs

	make_desktop_entry gens "Gens/GS" "/usr/share/games/gens/gensgs_48x48.png"
	prepgamesdirs
}
