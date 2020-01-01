# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/scummvm"
LIBRETRO_COMMIT_SHA="0c777c88c556e21acb9a0772790c7519acf499c6"

inherit libretro-core

DESCRIPTION="libretro implementation of ScummVM"
HOMEPAGE="https://github.com/libretro/scummvm"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
"
RDEPEND="
        ${DEPEND}
        games-emulation/libretro-info
"

S="${S}/backends/platform/libretro/build"
