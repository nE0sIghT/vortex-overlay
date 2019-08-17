# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="e7b2f6428f3ea80c33b3c9923204f6c2ae4be8ab"

inherit libretro-core

DESCRIPTION="Nestopia libretro port"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/libretro"

src_prepare() {
	default
	sed -i -e 's/-O2//g' Makefile || die
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"
	libretro-core_src_install
}
