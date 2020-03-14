# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/scummvm"
LIBRETRO_COMMIT_SHA="de91bf9bcbf4449f91e2f50fde173496a2b52ee0"

inherit libretro-core

DESCRIPTION="Interpreter for point-and-click adventure games as a libretro core."

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/backends/platform/libretro/build"
