# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="An object-oriented C++ wrapper for cURL tool"
HOMEPAGE="https://josephp91.github.io/curlcpp/"
SRC_URI="https://github.com/JosephP91/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-misc/curl:=
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-libdir.patch" )
