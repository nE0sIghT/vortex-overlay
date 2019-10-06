# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/${PN}"
LIBRETRO_COMMIT_SHA="3304c5ddcdcda9afa6cd0755dddacedd4a50dee7"

DESCRIPTION="RetroArch joypad autoconfig files"
HOMEPAGE="https://github.com/libretro/retroarch-joypad-autoconfig"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/${LIBRETRO_REPO_NAME}.git"

	inherit git-r3
else
	inherit vcs-snapshot

	SRC_URI="https://github.com/${LIBRETRO_REPO_NAME}/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC-BY-4.0"
SLOT="0"

src_prepare() {
	default
	sed -i -e "s/libretro/retroarch/g" Makefile || die
}
