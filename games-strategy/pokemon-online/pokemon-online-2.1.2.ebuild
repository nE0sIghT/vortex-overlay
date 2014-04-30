# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/qbittorrent/qbittorrent-9999.ebuild,v 1.9 2013/07/31 15:33:00 yngwin Exp $

EAPI=5

EGIT_REPO_URI="git://github.com/po-devs/pokemon-online.git"
EGIT_BRANCH="${PV}"

LANGS="de es fi fr he ko it jp nl pt-br zh-cn"

inherit qt4-r2 git-2 games

DESCRIPTION="Pokemon-online"
HOMEPAGE="http://pokemon-online.eu/"

LICENSE="GPL-3"
SLOT="2"
KEYWORDS="~x86 ~amd64"

IUSE="-plugins -server"

CDEPEND="dev-qt/qtcore:4
	dev-qt/qtphonon
	dev-qt/qtdeclarative
	dev-libs/libzip
"

DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="
	${CDEPEND}
	plugins? ( media-gfx/qrencode )"

DOCS="README.txt"

src_prepare() {
	# Respect LDFLAGS
	qt4-r2_src_prepare
}

src_configure() {
	local myconf
	use plugins   && myconf+=" po_clientplugins"
	if use server; then
		myconf+=" po_server"
		use plugins && myconf+=" po_serverplugins"
	fi

	rm -rf "${S}"/bin/trans/*
	for lang in ${LANGS}; do
		if ! use linguas_${lang}; then
			sed -i "s/src\/trans\/translation_${lang}.ts//" "${S}"/PokemonOnline.pro
			sed -i "/\(${lang}\)/d" "${S}"/bin/languages.txt
		else
			mkdir "${S}"/bin/trans/${lang}
			lrelease "${S}"/src/trans/translation_${lang}.ts -qm "${S}"/bin/trans/${lang}/translation_${lang}.qm
		fi
	done

	eqmake4 "CONFIG += debian_package release po_client ${myconf}"
}

src_install() {
	dogamesbin bin/Pokemon-Online
	dogameslib bin/*.so*

	insinto ${GAMES_DATADIR}/${PN}
	doins bin/{languages.txt,version.ini}
	doins -r bin/{db,qml,Music,Themes,trans}

	doicon "${FILESDIR}"/${PN}.xpm
	domenu "${FILESDIR}"/${PN}-client.desktop
	if use server; then
		dogamesbin bin/Pokemon-Online-Server
		domenu "${FILESDIR}"/${PN}-server.desktop

		use plugins && dogameslib bin/*.so*
	fi
}