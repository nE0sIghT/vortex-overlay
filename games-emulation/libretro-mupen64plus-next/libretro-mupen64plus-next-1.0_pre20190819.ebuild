# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mupen64plus-libretro-nx"
LIBRETRO_COMMIT_SHA="b785150465048fa88f812e23462f318e66af0be0"

inherit libretro-core toolchain-funcs

DESCRIPTION="Improved mupen64plus libretro core reimplementation"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	local ARCH=$(tc-arch)
	if [[ "${ARCH}" == "amd64" ]]; then
		ARCH="x86_64"
	fi

	myemakeargs="WITH_DYNAREC=${ARCH}" \
		libretro-core_src_compile
}
