# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="46a00f15e09ffbd4fba46ab41f0653aeea918fd1"

inherit vcs-snapshot

DESCRIPTION="Glsl shaders converted by hand from libretro's glsl-shaders repo"
HOMEPAGE="https://github.com/libretro/glsl-shaders"
SRC_URI="https://github.com/libretro/glsl-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
