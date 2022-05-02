# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="86cfa146a8dfddf6377ddb5dbcff552feae2e5bf"

inherit vcs-snapshot

DESCRIPTION="Collection of commonly used Cg shaders"
HOMEPAGE="https://github.com/libretro/common-shaders"
SRC_URI="https://github.com/libretro/common-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
