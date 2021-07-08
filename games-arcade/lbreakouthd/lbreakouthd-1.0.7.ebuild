# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

LB_LEVELS_V="20160512"
LB_THEMES_V="20160512"

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="http://lgames.sourceforge.net/LBreakoutHD/"
SRC_URI="
	mirror://sourceforge/lgames/${P}.tar.gz
	mirror://sourceforge/lgames/add-ons/lbreakout2/lbreakout2-levelsets-${LB_LEVELS_V}.tar.gz
	themes? ( mirror://sourceforge/lgames/add-ons/lbreakout2/lbreakout2-themes-${LB_LEVELS_V}.tar.gz )"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls themes"

RDEPEND="
	acct-group/gamestat
	media-libs/libpng:=
	media-libs/libsdl2[joystick,sound,video]
	media-libs/sdl2-image
	media-libs/sdl2-mixer
	media-libs/sdl2-net
	media-libs/sdl2-ttf
	nls? ( virtual/libintl )"
DEPEND="
	${RDEPEND}
	sys-libs/zlib"
BDEPEND="
	nls? ( sys-devel/gettext )
	themes? ( app-arch/unzip )"

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}/src/levels" || die
	unpack lbreakout2-levelsets-${LB_LEVELS_V}.tar.gz

	if use themes; then
		mkdir "${WORKDIR}"/themes || die
		cd "${WORKDIR}"/themes || die
		unpack lbreakout2-themes-${LB_THEMES_V}.tar.gz

		# Delete a few duplicate themes (already shipped with lbreakouthd
		# tarball). Some of them have different case than built-in themes, so it
		# is harder to just compare if the filename is the same.
		rm absoluteB.zip oz.zip moiree.zip || die
		local f
		for f in *.zip; do
			unpack ./${f}
			rm ${f} || die
		done
	fi
}

src_configure() {
	local econfargs=(
		$(use_enable nls)
		--localstatedir="${EPREFIX}"/var/games
	)
	econf "${econfargs[@]}"
}

src_install() {
	default

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.hscr
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.hscr

	if use themes; then
		insinto /usr/share/lbreakouthd/themes
		doins -r "${WORKDIR}"/themes/.
	fi

	make_desktop_entry ${PN} LBreakoutHD lbreakouthd256
}
