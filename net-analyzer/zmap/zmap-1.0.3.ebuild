# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-9999.ebuild,v 1.9 2013/07/31 15:33:00 yngwin Exp $

EAPI=5

inherit eutils

DESCRIPTION="ZMap"
HOMEPAGE="http://zmap.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE=""

RDEPEND="net-libs/libpcap
	dev-libs/gmp
	dev-util/gengetopt"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/"${PN}"-"${PV}"/src

src_prepare() {
	epatch "${FILESDIR}"/zmap-fortify-source.patch
	epatch "${FILESDIR}"/zmap-install.patch
}
