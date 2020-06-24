# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/SameBoy"
LIBRETRO_COMMIT_SHA="ef203cf0e5b6dd1e9ee5da47b0827b0ef132fa02"

inherit libretro-core

DESCRIPTION="Gameboy and Gameboy Color emulator written in C"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=sys-devel/rgbds-0.4.0"

S="${S}/libretro"

src_compile() {
	local myemakeargs=(
		"VERSION=${PV}"
	)
	libretro-core_src_compile
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${S}/../build/bin/${LIBRETRO_CORE_NAME}_libretro.so" \
		libretro-core_src_install
}
