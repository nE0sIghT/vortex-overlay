# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Simple aliases for use with portage"

HOMEPAGE="https://github.com/nE0sIghT/vortex-overlay"
SRC_URI=""

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="*"

RDEPEND="
	sys-apps/portage
"

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	for exe in {ew,pu,upg}; do
		doexe "${FILESDIR}/${exe}"
	done
}
