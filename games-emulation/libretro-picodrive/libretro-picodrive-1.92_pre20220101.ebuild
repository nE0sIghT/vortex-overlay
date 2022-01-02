# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/picodrive"
LIBRETRO_COMMIT_SHA="688c90d5bd017d21b9bcee99a4aa83c5224711a0"
DR_LIBS_COMMIT_SHA="343aa923439e59e7a9f7726f70edc77a4500bdec"
EMU2413_COMMIT_SHA="9f1dcf848d0e33e775e49352f7bc83a9c0e87a81"
LIBCHDR_COMMIT_SHA="00319cf31f034e4d468a49a60265c7c5b8305b70"

inherit libretro-core

DESCRIPTION="Fast MegaDrive/MegaCD/32X emulator"
SRC_URI="
	https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz
	https://github.com/mackron/dr_libs/archive/${DR_LIBS_COMMIT_SHA}.tar.gz -> ${P}-dr_libs.tar.gz
	https://github.com/digital-sound-antiques/emu2413/archive/${EMU2413_COMMIT_SHA}.tar.gz -> ${P}-emu2413.tar.gz
	https://github.com/rtissera/libchdr/archive/${LIBCHDR_COMMIT_SHA}.tar.gz -> ${P}-libchdr.tar.gz
"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_unpack() {
	default

	declare -A libraries=(
		[dr_libs]=platform/common/dr_libs
		[emu2413]=pico/sound/emu2413
		[libchdr]=pico/cd/libchdr
	)

	for library in "${!libraries[@]}"; do
		local commit_variable="${library^^}_COMMIT_SHA"
		mv "${WORKDIR}/${library}-${!commit_variable}"/* \
			"${S}/${libraries[$library]}/" || die
	done
}

src_configure() {
	:
}
