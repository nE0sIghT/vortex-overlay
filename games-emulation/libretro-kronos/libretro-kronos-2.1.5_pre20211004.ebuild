# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/yabause"
LIBRETRO_COMMIT_SHA="f2359c25f3fc7180be1ad890ba477ad415957ef6"

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
