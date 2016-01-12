# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils python-single-r1

DESCRIPTION="Native Google Chrome browser connector that provides integration with gnome-shell"
HOMEPAGE="https://github.com/nE0sIghT/chrome-gnome-shell"
SRC_URI="https://github.com/nE0sIghT/chrome-gnome-shell/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	dev-lang/python:2.7
	gnome-base/gnome-shell
"
DEPEND="${RDEPEND}
"

S="${WORKDIR}/chrome-gnome-shell-${PV}"

src_configure() {
	local mycmakeargs=( -DBUILD_EXTENSION=OFF )
	cmake-utils_src_configure
}

pkg_postinst() {
	echo
	elog "You must install Gnome-shell integration extension from"
	elog "Google Chrome store: https://goo.gl/JHCUS9 to work with"
	elog "Gnome-shell extensions repository at https://extensions.gnome.org"
	echo
	elog "After package update make sure you restarted Chrome/Chromium."
	echo
}
