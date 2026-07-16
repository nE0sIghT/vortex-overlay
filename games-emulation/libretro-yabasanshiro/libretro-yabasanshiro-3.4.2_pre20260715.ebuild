# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/yabause"
LIBRETRO_COMMIT_SHA="f448097b69a6037246a08e9dc09eabaa420d7893"

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
