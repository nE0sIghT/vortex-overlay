# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes-libretro"
LIBRETRO_COMMIT_SHA="41fe3ece28ee1d7ae546e777daffe1720fc1b7d1"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# No tests provided
RESTRICT="test"

BSNES_PROFILES=(
	accuracy
	balanced
	performance
)

src_compile() {
	for profile in "${BSNES_PROFILES[@]}"; do
		einfo "Building core with profile ${profile}"
		myemakeargs="profile=${profile}" \
			libretro-core_src_compile
	done
}

src_install() {
	for profile in "${BSNES_PROFILES[@]}"; do
		LIBRETRO_CORE_LIB_FILE="${S}/out/${PN#libretro-}_${profile}_libretro.so" \
			libretro-core_src_install
	done
}
