# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/bsnes-libretro"
LIBRETRO_COMMIT_SHA="d62d219ac22f1ed179738d107d8a4da2c4289845"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# No tests provided
RESTRICT="test"

src_compile() {
	myemakeargs="target=libretro binary=library local=false platform=linux" \
		libretro-core_src_compile
}
