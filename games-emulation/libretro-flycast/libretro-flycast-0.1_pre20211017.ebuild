# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/flycast"
LIBRETRO_COMMIT_SHA="4a913e063c95d1fae98afc64645831de0bcad57e"

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
