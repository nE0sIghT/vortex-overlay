# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vbam-libretro"
LIBRETRO_COMMIT_SHA="7c25d64d6903c6d859cce781c52da0671c4f7d3e"

inherit libretro-core

DESCRIPTION="A fork of VBA-M with libretro integration"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/src/libretro"
