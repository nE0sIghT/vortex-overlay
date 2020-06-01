# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/desmume"
LIBRETRO_COMMIT_SHA="6f520c816303a00a777817dc6a1a8d04ced336ea"

inherit libretro-core

DESCRIPTION="Port of Nintendo DS emulator DeSmuME to libretro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}
	>=net-libs/libpcap-1.8.1-r2
"

S="${S}/desmume/src/frontend/libretro"
