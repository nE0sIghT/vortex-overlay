# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vbam-libretro"
LIBRETRO_COMMIT_SHA="5d28c5ad39c5b3f46a771d98e298186e4990e833"

inherit libretro-core

DESCRIPTION="A fork of VBA-M with libretro integration"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/src/libretro"
