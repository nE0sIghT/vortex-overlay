# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="18d0962a593ec94ee1eb9073e023d08af6f31c01"

inherit libretro-core

DESCRIPTION="Nestopia libretro port"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/libretro"
