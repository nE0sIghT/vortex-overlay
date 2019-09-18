# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/${PN}"
LIBRETRO_COMMIT_SHA="ffffb2cf4dc5586de41e4e2ae2ca7533c472178e"

DESCRIPTION="Assets needed for RetroArch. Also contains the official branding."
HOMEPAGE="https://github.com/libretro/retroarch-assets"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${LIBRETRO_REPO_NAME}.git"

	inherit git-r3
else
	inherit vcs-snapshot

	SRC_URI="https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC-BY-4.0"
SLOT="0"

IUSE="materialui ozone rgui xmb"

RDEPEND="
	materialui? ( !!<games-emulation/retroarch-1.7.8 )
	ozone? ( !!<games-emulation/retroarch-1.7.8 )
	rgui? ( !!<games-emulation/retroarch-1.7.8 )
	xmb? ( !!<games-emulation/retroarch-1.7.8 )
"

src_prepare() {
	default

	sed -i -e "s/libretro/retroarch/g" Makefile || die

	declare -A FLAGS=( [materialui]=glui [ozone]= [rgui]= [xmb]= )
	for flag in "${!FLAGS[@]}"; do
		if ! use "${flag}"; then
			local folder="${FLAGS[$flag]:-$flag}"
			rm -r "${folder}" || die
		fi
	done
}
