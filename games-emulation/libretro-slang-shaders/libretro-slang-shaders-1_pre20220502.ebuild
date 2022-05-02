# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="1bd12dc7cd9f2f0184103f69f0599e5ac9275dba"

inherit vcs-snapshot

DESCRIPTION="Vulkan GLSL RetroArch shaders"
HOMEPAGE="https://github.com/libretro/slang-shaders"
SRC_URI="https://github.com/libretro/slang-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
