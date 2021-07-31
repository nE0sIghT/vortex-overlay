# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/picodrive"
LIBRETRO_COMMIT_SHA="f7fb6851f1f2c9debf47861ac22342e9e43d0152"

inherit libretro-core

DESCRIPTION="Fast MegaDrive/MegaCD/32X emulator"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	:
}
