# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/picodrive"
LIBRETRO_COMMIT_SHA="b8fb8f285317632f42ecbbd36cf4fe18ea9189f1"

inherit libretro-core

DESCRIPTION="Fast MegaDrive/MegaCD/32X emulator"

LICENSE="XMAME"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_configure() {
	:
}
