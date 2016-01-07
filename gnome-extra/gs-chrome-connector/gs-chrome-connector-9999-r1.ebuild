# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1

DESCRIPTION="Native Google Chrome browser connector that provides integration with gnome-shell"
HOMEPAGE="https://github.com/nE0sIghT/chrome-gnome-shell"
EGIT_REPO_URI=(
	"https://github.com/nE0sIghT/chrome-gnome-shell.git"
	"git://github.com/nE0sIghT/chrome-gnome-shell.git"
)

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lang/python:2.7
	gnome-base/gnome-shell
"
DEPEND="${RDEPEND}
"

src_configure() {
	local mycmakeargs=( -DBUILD_EXTENSION=OFF )
	cmake-utils_src_configure
}

pkg_postinst() {
	echo
	elog "You must install Gnome-shell integration extension from"
	elog "Google Chrome store: https://goo.gl/8INFcP to work with"
	elog "Gnome-shell extensions repository at https://extensions.gnome.org"
	echo
}
