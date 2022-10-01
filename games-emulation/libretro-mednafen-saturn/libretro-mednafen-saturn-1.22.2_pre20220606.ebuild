# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-saturn-libretro"
LIBRETRO_COMMIT_SHA="ccf701b7b749e50342d12bc01f8ef1cb43112bb1"

inherit libretro-core

DESCRIPTION="Mednafen Saturn"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/opengl
"
DEPEND="${RDEPEND}"

#src_install() {
#	LIBRETRO_CORE_LIB_FILE="${S}/mednafen_saturn_libretro.so" \
#		libretro-core_src_install
#}
