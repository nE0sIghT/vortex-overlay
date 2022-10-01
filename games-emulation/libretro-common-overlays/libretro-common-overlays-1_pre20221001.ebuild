# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="e2ba730083769b45bac62d164115e7dc197c8b63"

inherit vcs-snapshot

DESCRIPTION="Collection of overlay files for use with RetroArch"
HOMEPAGE="https://github.com/libretro/common-overlays"
SRC_URI="https://github.com/libretro/common-overlays/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/retroarch/overlay"
	doins -r *
}
