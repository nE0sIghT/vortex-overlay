# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="9271cc2d3adb2e2c46eb48a16141e9de2112ddcd"

inherit vcs-snapshot

DESCRIPTION="Vulkan GLSL RetroArch shaders"
HOMEPAGE="https://github.com/libretro/slang-shaders"
SRC_URI="https://github.com/libretro/slang-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
