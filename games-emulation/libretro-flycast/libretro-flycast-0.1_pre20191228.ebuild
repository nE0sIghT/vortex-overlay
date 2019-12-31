# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/flycast"
LIBRETRO_COMMIT_SHA="60ed83a34ec018f6025c19cccb3b268ed8434b78"

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
