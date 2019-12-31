# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vcs-snapshot

LIBRETRO_REPO_NAME="libretro/${PN}"
LIBRETRO_COMMIT_SHA="443b36d99f1ae4c43c2473f645ed5ae0de2a0c45"

DESCRIPTION="RetroArch joypad autoconfig files"
HOMEPAGE="https://github.com/libretro/retroarch-joypad-autoconfig"
SRC_URI="https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	sed -i -e "s/libretro/retroarch/g" Makefile || die
}
