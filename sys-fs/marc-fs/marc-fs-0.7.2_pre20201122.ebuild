# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake vcs-snapshot

COMMIT_SHA="7df8259cdfd3133f159488a2ee9805c8096b2c18"
MY_PN=${PN^^}

DESCRIPTION="FUSE filesystem attempt for Mail.Ru Cloud"
HOMEPAGE="https://gitlab.com/Kanedias/MARC-FS"
SRC_URI="https://gitlab.com/Kanedias/${MY_PN}/-/archive/${COMMIT_SHA}/${MY_PN}-${COMMIT_SHA}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jemalloc"
# Requires googletest
RESTRICT="test"

RDEPEND="
	dev-cpp/curlcpp
	dev-libs/jemalloc
	dev-libs/jsoncpp
	sys-fs/fuse:3
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_JEMALLOC="$(usex jemalloc)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dosbin "${FILESDIR}/mount.marcfs"
}
