# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vbam-libretro"
LIBRETRO_COMMIT_SHA="6bdd6d1b22e40cfe715f05bc6653936eae40658f"

inherit libretro-core

DESCRIPTION="A fork of VBA-M with libretro integration"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/src/libretro"

src_prepare() {
	default
	sed -i -e 's/-O2//g' Makefile || die
}
