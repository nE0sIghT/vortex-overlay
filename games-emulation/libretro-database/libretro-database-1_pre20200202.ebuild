# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="95039bc1338d204911cf72f94e1622b3223f4e32"

inherit vcs-snapshot

DESCRIPTION="Cheatcode files, content data files and etc. stuff for RetroArch"
HOMEPAGE="https://github.com/libretro/libretro-database"
SRC_URI="https://github.com/libretro/libretro-database/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	:
}
