# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/SameBoy"
LIBRETRO_COMMIT_SHA="3b635244f1cf3e96b9bab93dc42b217fab3de478"

inherit libretro-core

DESCRIPTION="Gameboy and Gameboy Color emulator written in C"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-devel/rgbds"

S="${S}/libretro"

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/../build/bin/${LIBRETRO_CORE_NAME}_libretro.so" \
		libretro-core_src_install
}
