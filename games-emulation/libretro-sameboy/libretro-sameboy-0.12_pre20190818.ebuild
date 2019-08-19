# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/SameBoy"
LIBRETRO_COMMIT_SHA="fc754112163a2f6157c56092ea6e1fd64500c4cc"

inherit libretro-core

DESCRIPTION="Gameboy and Gameboy Color emulator written in C"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-devel/rgbds"

S="${S}/libretro"

src_compile() {
	# Parallel make is failing with -j5
	myemakeargs=-j1 libretro-core_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE:="${S}/../build/bin${LIBRETRO_CORE_NAME}_libretro.so" \
		libretro-core_src_install
}