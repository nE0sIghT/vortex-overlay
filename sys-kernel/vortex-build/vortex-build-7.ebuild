# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils optfeature

DESCRIPTION="Simple Linux kernel build scripts"

HOMEPAGE="https://github.com/nE0sIghT/vortex-overlay"
SRC_URI=""

LICENSE="GPL-3"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	app-admin/eselect
	app-alternatives/awk
	app-arch/gzip
	sys-apps/coreutils
	sys-apps/gentoo-functions
	sys-apps/grep
	sys-apps/portage
	sys-apps/util-linux
"

S="${WORKDIR}"

CONFIG_CHECK="~IKCONFIG_PROC"

src_install() {
	exeinto /usr/bin
	for exe in {build_kernel-r4,prepare_kernel-r1}; do
		sed -e "s#@libdir@#$(get_libdir)#g" "${FILESDIR}/${exe}" > "${T}/${exe%-*}" || die
		doexe "${T}/${exe%-*}"
	done

	insinto /usr/$(get_libdir)/${PN}
	doins "${FILESDIR}"/vortex-functions.sh

	insinto /etc/default
	newins "${FILESDIR}"/${PN}-r3 ${PN}
}

pkg_postinst() {
	elog "Before running build_kernel for the first time,"
	elog "you will need setup its configuration /etc/default/${PN}."

	optfeature "signing kernel" app-crypt/sbsigntools
}
