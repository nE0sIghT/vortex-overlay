# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="ea6f1c0631bb62bf15ab96493127dd9cfaf74d1c"

inherit libretro-core

DESCRIPTION="Nestopia libretro port"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/libretro"
