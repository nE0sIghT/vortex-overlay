# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/microcode-data/microcode-data-20150121.ebuild,v 1.1 2015/02/08 09:28:49 hwoarang Exp $

EAPI="4"

inherit linux-info toolchain-funcs

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

NUM="24661"
DESCRIPTION="Intel IA32 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/Detail_Desc.aspx?DwnldID=${NUM}"
SRC_URI="http://downloadmirror.intel.com/${NUM}/eng/microcode-${PV}.tgz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="monolitic"

RDEPEND="
	monolitic? ( !<sys-apps/microcode-ctl-1.17-r2 )
"

S=${WORKDIR}

if ! use monolitic; then
	CONFIG_CHECK="~MICROCODE_INTEL"
	ERROR_MICROCODE_INTEL="Your kernel needs to support Intel microcode loading. You're suggested to build it as a module as it doesn't require a reboot to reload the microcode, that way."
fi

src_unpack() {
	default
	if ! use monolitic; then
		cp "${FILESDIR}"/intel-microcode2ucode.c ./ || die
	fi
}

src_compile() {
	if ! use monolitic; then
		tc-env_build emake intel-microcode2ucode
		./intel-microcode2ucode microcode.dat || die
	fi
}

src_install() {
	insinto /lib/firmware
	if ! use monolitic; then
		doins -r microcode.dat intel-ucode
	else
		doins -r intel-ucode
	fi
}

pkg_postinst() {
	elog "The microcode available for Intel CPUs has been updated.  You'll need"
	elog "to reload the code into your processor."
	if use monolitic; then
		elog "If you're using the init.d:"
		elog "/etc/init.d/microcode_ctl restart"
	fi
}
