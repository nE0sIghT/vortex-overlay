# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Provides integration with GNOME Shell extensions repository for Chrome browser"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeShellIntegrationForChrome"
EGIT_REPO_URI="git://git.gnome.org/chrome-gnome-shell"
EGIT_BRANCH="feature/distutils"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	gnome-base/gnome-shell
"
DEPEND="${PYTHON_DEPS}"

src_configure() {
	python_setup

	local mycmakeargs=( -DBUILD_EXTENSION=OFF )
	cmake-utils_src_configure
}
