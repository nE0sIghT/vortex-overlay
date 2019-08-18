# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mgba"
LIBRETRO_COMMIT_SHA="8cf7b434fefb52be8bb3effe61e8fb16e9297733"

inherit libretro-core

DESCRIPTION="mGBA Game Boy Advance Emulator"

LICENSE="MPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i -e 's/-O3//g' libretro-build/Makefile.linux* || die
}
