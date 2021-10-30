# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dosbox-pure"
LIBRETRO_COMMIT_SHA="4d70760d65140c97634d2d6e8a9876e571790670"

inherit libretro-core

DESCRIPTION="DOS emulator, built for RetroArch/Libretro aiming for simplicity and ease of use"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}"

#S="${S}/desmume/src/frontend/libretro"
