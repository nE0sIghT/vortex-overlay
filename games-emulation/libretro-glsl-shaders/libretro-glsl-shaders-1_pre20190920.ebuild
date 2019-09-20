# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="6126c0481c430789620b578b3362ec467b6b9975"

DESCRIPTION="Glsl shaders converted by hand from libretro's glsl-shaders repo"
HOMEPAGE="https://github.com/libretro/glsl-shaders"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/libretro/glsl-shaders"

	inherit git-r3
else
	inherit vcs-snapshot

	SRC_URI="https://github.com/libretro/glsl-shaders/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
