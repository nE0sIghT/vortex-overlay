# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/desmume"
LIBRETRO_COMMIT_SHA="7f05a8d447b00acd9e0798aee97b4f72eb505ef9"

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
