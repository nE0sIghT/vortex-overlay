# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Video conferencing and web conferencing service"
HOMEPAGE="https://dion.vc/"
SRC_URI="https://static.dion.vc/desktop_app/${PN}_${PV}_amd64.deb"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="splitdebug"

#RDEPEND=""
#DEPEND="${RDEPEND}"

QA_PREBUILT="
	opt/Dion/chrome-sandbox
	opt/Dion/chrome_crashpad_handler
	opt/Dion/dion
	opt/Dion/libEGL.so
	opt/Dion/libGLESv2.so
	opt/Dion/libffmpeg.so
	opt/Dion/libvk_swiftshader.so
	opt/Dion/libvulkan.so.1
"

src_prepare() {
	default
	rm opt/Dion/{LICENSE.electron.txt,LICENSES.chromium.html} || die
}

src_install() {
	mv usr/share/doc/${PN} usr/share/doc/${PF} || die
	gunzip usr/share/doc/${PF}/changelog.gz || die

	insinto /
	doins -r usr
	doins -r opt
	local f
	for f in ${QA_PREBUILT}; do
		fperms +x "/${f}"
	done

	fperms u+s /opt/Dion/chrome-sandbox

	dosym ../../opt/Dion/${PN} /usr/bin/${PN}
}
