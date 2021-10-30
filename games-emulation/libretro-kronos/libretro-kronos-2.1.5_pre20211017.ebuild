# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/yabause"
LIBRETRO_COMMIT_SHA="9b701fa1cf9e754908c8994128db957a9bba1260"

inherit libretro-core

DESCRIPTION="Sega Saturn Emulated Hardware"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libbsd
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb
"
DEPEND="${RDEPEND}"

S="${S}/yabause/src/libretro"
