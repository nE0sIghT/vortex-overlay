# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/yabause"
LIBRETRO_COMMIT_SHA="9f05806df4d94ae08636208bcc2a5eb37c961bf9"

inherit libretro-core

DESCRIPTION="Yabause/YabaSanshiro/Kronos libretro ports (Sega Saturn emulators)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/yabause/src/libretro"
