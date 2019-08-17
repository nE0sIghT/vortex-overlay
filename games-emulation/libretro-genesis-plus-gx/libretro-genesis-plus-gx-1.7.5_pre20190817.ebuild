# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/Genesis-Plus-GX"
LIBRETRO_CORE_NAME=${PN#libretro-}
LIBRETRO_CORE_NAME=${LIBRETRO_CORE_NAME//-/_}
LIBRETRO_COMMIT_SHA="5299257db3297deb8fb776e75c72e495965448ac"

inherit libretro-core

LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"

DESCRIPTION="An enhanced port of Genesis Plus - accurate & portable Sega 8/16 bit emulator"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"
