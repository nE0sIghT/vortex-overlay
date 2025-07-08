# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
COMMIT_SHA="66ddfee6fb6b8515fb8a27698acbb9b2b8e9d2c2"

inherit linux-mod-r1 vcs-snapshot

DESCRIPTION="Kernel module for the Nuvoton NCT6687-R"
HOMEPAGE="https://github.com/Fred78290/nct6687d"
SRC_URI="https://github.com/Fred78290/${PN}/archive/${COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/linux-sources"

src_compile() {
	local modlist=( nct6687=drivers/hwmon::${KV_FULL}:build )
	local modargs=( kver="${KV_FULL}" )
	linux-mod-r1_src_compile
}
