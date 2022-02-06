# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="def66a58f0c0b38cdf72909ff9d9480344a98032"

inherit libretro-core

DESCRIPTION="Nestopia libretro port"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/libretro"
