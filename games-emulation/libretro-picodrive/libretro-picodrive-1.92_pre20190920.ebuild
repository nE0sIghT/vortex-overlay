# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/picodrive"
LIBRETRO_COMMIT_SHA="28dcfd6f43434e6828ee647223a0576bfe858c24"

inherit libretro-core

DESCRIPTION="Fast MegaDrive/MegaCD/32X emulator"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	: 
}
