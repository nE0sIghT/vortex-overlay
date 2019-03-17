# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod systemd udev

DESCRIPTION="Detects DDC/CI devices on DDC I2C busses and creates corresponding devices."
HOMEPAGE="https://gitlab.com/ddcci-driver-linux/ddcci-driver-linux"
SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nvidia systemd"
REQUIRED_USE="nvidia? ( systemd )"

RDEPEND="systemd? ( app-misc/ddcutil )"

S="${WORKDIR}/${PN}-v${PV}"

BUILD_TARGETS="module"
MODULE_NAMES="ddcci(misc:ddcci) ddcci-backlight(misc:ddcci-backlight)"

src_install() {
	linux-mod_src_install

	if use nvidia; then
		udev_dorules "${FILESDIR}"/99-ddcci.rules
	fi

	if use systemd; then
		systemd_dounit "${FILESDIR}"/ddcci@.service
	fi
}

pkg_postinst() {
	linux-mod_pkg_postinst

	if use nvidia; then
		udev_reload
	fi
}

pkg_postrm() {
	linux-mod_pkg_postinst

	if use nvidia; then
		udev_reload
	fi
}
