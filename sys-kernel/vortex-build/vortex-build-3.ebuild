# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Simple Linux kernel build scripts"

HOMEPAGE="https://github.com/nE0sIghT/vortex-overlay"
SRC_URI=""

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="*"

RDEPEND="
	app-admin/eselect
	app-arch/gzip
	sys-apps/coreutils
	sys-apps/gentoo-functions
	sys-apps/grep
	sys-apps/portage
	sys-apps/util-linux
	virtual/awk
"

S="${WORKDIR}"

CONFIG_CHECK="~IKCONFIG_PROC"

src_install() {
	exeinto /usr/bin
	for exe in {build_kernel-r1,prepare_kernel}; do
		newexe "${FILESDIR}/${exe}" "${exe%-*}"
	done

	insinto /usr/$(get_libdir)/${PN}
	doins "${FILESDIR}"/vortex-functions.sh

	insinto /etc/default
	newins "${FILESDIR}"/${PN}-r1 ${PN}
}

pkg_postinst() {
	elog "Before running build_kernel for the first time,"
	elog "you will need setup its configuration /etc/default/${PN}."
}
