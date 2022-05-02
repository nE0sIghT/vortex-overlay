# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="05f30445a0ac39cf8f6c89caf4edc3233189353d"

inherit vcs-snapshot

DESCRIPTION="Libretro info files required for libretro cores"
HOMEPAGE="https://github.com/libretro/libretro-super"
SRC_URI="https://github.com/libretro/libretro-super/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/libretro/info"
	doins dist/info/*.info
}
