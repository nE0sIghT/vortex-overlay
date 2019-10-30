# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/flycast"
LIBRETRO_COMMIT_SHA="f191ee8da8dce7ea67ea135109b441914ea1e95c"

inherit libretro-core toolchain-funcs

DESCRIPTION="Multiplatform Sega Dreamcast emulator"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/opengl"
DEPEND="${RDEPEND}"

src_compile() {
	local ARCH=$(tc-arch)
	if [[ "${ARCH}" == "amd64" ]]; then
		ARCH="x86_64"
	fi

	libretro-core_src_compile
}
