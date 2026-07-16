# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LIBRETRO_COMMIT_SHA="9c0d839a19651dffc9898da7673574a20fb39415"

inherit vcs-snapshot

DESCRIPTION="Collection of commonly used Cg shaders"
HOMEPAGE="https://github.com/libretro/common-shaders"
SRC_URI="https://github.com/libretro/common-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
