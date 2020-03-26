# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
COMMIT_SHA="fd69de1a1b960ec296cc67d32257b0f9e2d89ac6"

inherit cmake-utils vcs-snapshot

DESCRIPTION="3DS shader assembler and disassembler"
HOMEPAGE="https://github.com/neobrain/nihstro"
SRC_URI="https://github.com/neobrain/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"

src_install() {
	cmake-utils_src_install
	insinto /usr/include
	doins -r include/*
}
