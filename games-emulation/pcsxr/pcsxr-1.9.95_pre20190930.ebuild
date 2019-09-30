# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils vcs-snapshot

DESCRIPTION="PCSX-Reloaded: a fork of PCSX, the discontinued Playstation emulator"
HOMEPAGE="https://github.com/iCatButler/pcsxr"
SRC_URI="https://github.com/iCatButler/pcsxr/archive/62467b86871aee3d70c7445f3cb79f0858ec566e.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 public-domain"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa cdio ffmpeg libav nls openal opengl oss pulseaudio +sdl"
REQUIRED_USE="?? ( alsa openal oss pulseaudio sdl )"

# pcsxr supports both SDL1 and SDL2 but uses the newer version installed
# since SDL is not properly slotted in Gentoo, just fix it on SDL2

RDEPEND="
	dev-libs/glib:2=
	media-libs/libsdl:0=[joystick]
	sys-libs/zlib:0=
	x11-libs/gtk+:3=
	x11-libs/libX11:0=
	x11-libs/libXext:0=
	x11-libs/libXtst:0=
	x11-libs/libXv:0=
	alsa? ( media-libs/alsa-lib:0= )
	cdio? ( dev-libs/libcdio:0= )
	ffmpeg? (
		!libav? ( >=media-video/ffmpeg-3:0= )
		libav? ( media-video/libav:0= ) )
	nls? ( virtual/libintl:0= )
	openal? ( media-libs/openal:0= )
	opengl? ( virtual/opengl:0=
		x11-libs/libXxf86vm:0= )
	pulseaudio? ( media-sound/pulseaudio:0= )
	sdl? ( media-libs/libsdl:0=[sound] )
"
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-util/intltool
	x11-base/xorg-proto
	nls? ( sys-devel/gettext:0 )
	x86? ( dev-lang/nasm )
"
