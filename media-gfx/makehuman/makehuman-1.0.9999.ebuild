# Copyright 2008-2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit mercurial eutils

DESCRIPTION="Software for the modelling of 3D humanoid characters."
HOMEPAGE="http://www.makehuman.org/"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/MakeHuman/makehuman"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="aqsis"

DEPEND="
dev-lang/python:2.7
media-libs/sdl-image
media-libs/mesa
media-libs/glew
aqsis? ( media-gfx/aqsis )
"

RDEPEND="
dev-vcs/subversion
${DEPEND}"

src_prepare() {
	subversion_src_unpack
	epatch ${FILESDIR}/Makefile.Linux.patch
}

src_compile() {
	make -f Makefile.Linux
}

src_install() {
	INST_DIR="${D}opt/makehuman"
	install -d -m755 $INST_DIR
	cp -a {makehuman,main.py,apps,backgrounds,core,data,plugins,shared} $INST_DIR
	install -d -m755 "${D}usr/bin/"
	cp -a ${FILESDIR}/makehuman_launcher.sh "${D}usr/bin/makehuman"
	install -d -m755 "${D}usr/share/doc/makehuman"
	cp -a docs/* "${D}usr/share/doc/makehuman/"
	install -d -m755 "${D}usr/share/applications"
	cp -a ${FILESDIR}/makehuman.desktop "${D}usr/share/applications"
	install -d -m755 "${D}usr/share/pixmaps"
	cp -a ${FILESDIR}/makehuman.png "${D}usr/share/pixmaps/"
}
