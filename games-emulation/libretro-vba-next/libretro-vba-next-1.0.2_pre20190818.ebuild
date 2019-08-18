# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vba-next"
LIBRETRO_COMMIT_SHA="aeef7de644fa1fb8390dacdc725d32ee81bf5554"

inherit libretro-core

DESCRIPTION="Optimized port of VBA-M to Libretro"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i -e 's/-O2//g' Makefile.libretro || die
}
