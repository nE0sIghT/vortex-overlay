# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/google-talkplugin/google-talkplugin-9999.ebuild,v 1.16 2013/07/31 15:20:03 ottxor Exp $

EAPI=5

inherit eutils nsplugins git-2

EGIT_REPO_URI="https://bitbucket.org/mmueller2012/pipelight.git"

DESCRIPTION="Windows NPAPI plugins into linux browsers using wine and a pipe"

HOMEPAGE="https://launchpad.net/pipelight"
IUSE=""
SLOT="0"

KEYWORDS=""
LICENSE="|| ( GPL-2 LGPL-2.1 MPL-1.1 )"

RDEPEND=""

DEPEND="sys-devel/crossdev"

S="${WORKDIR}"

src_prepare() {
	if [ ! -f /usr/bin/i686-w64-mingw32-gcc ]; then
		eerror "You should manually install cross compilator for i686-w64-mingw32 target using crossdev"
		die
	fi
}

src_configure() {
	econf \
		--moz-plugin-path=/usr/$(get_libdir)/"$PLUGINS_DIR" \
		--gcc-runtime-dlls=/usr/lib64/gcc/i686-w64-mingw32/4.8.1 \
		--wine-path=/usr/bin/wine
}
