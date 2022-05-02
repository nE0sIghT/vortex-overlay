# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-pcfx-libretro"
LIBRETRO_COMMIT_SHA="bfc0954e14b261a04dcf8dbe0df8798f16ae3f3c"

inherit libretro-core

DESCRIPTION="Standalone port of Mednafen PCFX to libretro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
