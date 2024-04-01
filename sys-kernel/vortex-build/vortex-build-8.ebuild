# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Simple Linux kernel build scripts"

HOMEPAGE="https://github.com/nE0sIghT/vortex-overlay"
SRC_URI=""

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-admin/sudo
	app-arch/gzip
	sys-apps/gentoo-functions
	sys-apps/portage
	sys-kernel/gentoo-kernel
"

S="${WORKDIR}"

CONFIG_CHECK="~IKCONFIG_PROC"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}/kernel-build"

	dosym kernel-build /usr/bin/build_kernel

	echo "CONFIG_PROTECT_MASK=\"/etc/portage/patches/sys-apps/portage/portage-gentoo-kernel-interactive.patch\"" > 50${PN}
	doenvd 50${PN}

	insinto /etc/portage/patches/sys-apps/portage
	doins "${FILESDIR}/portage-gentoo-kernel-interactive.patch"

	insinto /etc/portage/env/sys-kernel
	doins "${FILESDIR}/gentoo-kernel"
}

pkg_postinst() {
	ewarn "Since version 8 vortex-build uses sys-kernel/gentoo-kernel."
	ewarn "User patch for sys-apps/portage was installed. Please rebuild portage."
}

pkg_postrm() {
	ewarn "Portage environment file for sys-kernel/gentoo-kernel was not uninstalled."
	ewarn "Please do rm /etc/portage/env/sys-kernel/gentoo-kernel if needed."
}
