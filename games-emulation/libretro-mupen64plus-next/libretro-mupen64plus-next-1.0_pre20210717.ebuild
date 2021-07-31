# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/mupen64plus-libretro-nx"
LIBRETRO_COMMIT_SHA="b4024d75597da162bbc7cb693b8cef0d6da75105"

inherit libretro-core toolchain-funcs

DESCRIPTION="Improved mupen64plus libretro core reimplementation"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:=
	virtual/opengl
"
DEPEND="${RDEPEND}
	dev-lang/nasm
"

src_compile() {
	local ARCH=$(tc-arch)
	if [[ "${ARCH}" == "amd64" ]]; then
		ARCH="x86_64"
	fi

	myemakeargs="WITH_DYNAREC=${ARCH}" \
		libretro-core_src_compile
}
