# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Reliable MTP client with minimalistic UI"
HOMEPAGE="https://whoozle.github.io/android-file-transfer-linux/"

SRC_URI="https://github.com/whoozle/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="fuse gui"

RDEPEND="
	fuse? ( sys-fs/fuse )
	gui? (
		|| (
			dev-qt/qtwidgets:5
			dev-qt/qtgui:4
		)
	)
"
DEPEND="${RDEPEND}

	virtual/pkgconfig
"

#S=${WORKDIR}/${P}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build gui QT_UI)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use gui; then
		make_desktop_entry android-file-transfer \
			"Android File Transfer For Linux"
	fi
}
