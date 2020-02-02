# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-saturn-libretro"
LIBRETRO_COMMIT_SHA="3313cc6760c14cffa9226e0cfd41debc11df8bdd"

inherit libretro-core

DESCRIPTION="Standalone port of Mednafen Saturn to the libretro API"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
