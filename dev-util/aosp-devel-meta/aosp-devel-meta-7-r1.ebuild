# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package providing AOSP build environment"
HOMEPAGE="https://source.android.com/source/initializing"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	app-crypt/gnupg
	app-arch/zip[-natspec]
	app-arch/unzip
	>=dev-java/icedtea-3.4.0:8
	dev-libs/libxslt
	dev-libs/libxml2
	dev-util/android-tools
	dev-util/ccache
	dev-util/gperf
	dev-vcs/git
	media-libs/libsdl
	media-libs/mesa
	net-misc/curl
	net-misc/rsync
	sys-devel/bc
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc[cxx]
	sys-libs/ncurses-compat:5=[abi_x86_32,tinfo]
	sys-libs/readline[abi_x86_32]
	sys-libs/zlib[abi_x86_32]
	sys-process/schedtool
	sys-fs/squashfs-tools
	x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/wxGTK:3.0
"
