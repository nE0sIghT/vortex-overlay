# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes-libretro"
LIBRETRO_COMMIT_SHA="f8cdeee82b2a699001c222c7e696a4e7730b0702"

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
