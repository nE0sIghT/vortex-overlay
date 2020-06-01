# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mgba"
LIBRETRO_COMMIT_SHA="7ad318f5f683b447db7bd8ef4a7a8f3570e8eca9"

inherit libretro-core

DESCRIPTION="mGBA Game Boy Advance Emulator"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i -e 's/-O3//g' libretro-build/Makefile.linux* || die
}
