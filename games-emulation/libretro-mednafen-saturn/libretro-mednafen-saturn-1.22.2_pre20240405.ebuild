# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/beetle-saturn-libretro"
LIBRETRO_COMMIT_SHA="8192ecca34d44f8f85175fa7b7fab6ec2ffb31c2"

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
