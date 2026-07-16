# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_REPO_NAME="libretro/beetle-pcfx-libretro"
LIBRETRO_COMMIT_SHA="650c30ea2203636a1716675854d11c608ed6eacc"

inherit libretro-core

DESCRIPTION="Standalone port of Mednafen PCFX to libretro"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
