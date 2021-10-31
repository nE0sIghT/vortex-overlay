# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/bsnes-libretro"
LIBRETRO_COMMIT_SHA="b30bbe57c1e55b3ace744c851b81c0656d2367e4"

inherit libretro-core

DESCRIPTION="Libretro fork of bsnes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# No tests provided
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-0.14.4-gb_version.patch"
)

src_compile() {
	myemakeargs="target=libretro binary=library local=false platform=linux" \
		libretro-core_src_compile
}
