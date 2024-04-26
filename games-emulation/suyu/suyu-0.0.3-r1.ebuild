# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMPATIBILITY_LIST_COMMIT_SHA="00709ad0aa83f174a09d567ed5a0b3a24d8a6817"
SIRIT_COMMIT_SHA="ab75463999f4f3291976b079d42d52ee91eebf3f"
TZDB_TO_NX_COMMIT_SHA="97929690234f2b4add36b33657fe3fe09bd57dfd"

inherit cmake

DESCRIPTION="A familiar, open source, and powerful Nintendo Switch emulator"
HOMEPAGE="https://suyu.dev/"
SRC_URI="
	https://git.suyu.dev/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/yuzu-mirror/api/${COMPATIBILITY_LIST_COMMIT_SHA}/gamedb/websiteFeed -> ${P}-compatibility_list.json
	https://git.suyu.dev/suyu/sirit/archive/${SIRIT_COMMIT_SHA}.tar.gz -> ${PN}-sirit.tar.gz
	https://github.com/lat9nq/tzdb_to_nx/archive/${TZDB_TO_NX_COMMIT_SHA}.tar.gz -> ${PN}-tzdb-to-nx.tar.gz
"
S="${WORKDIR}/${PN}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	>=dev-cpp/simpleini-4.22-r1
	dev-libs/dynarmic
	dev-libs/libffi:=
	dev-libs/libfmt:=
	dev-libs/libxml2
	dev-qt/qtmultimedia:6
	media-libs/cubeb
	media-libs/opus
	media-video/ffmpeg:=
	net-libs/enet:1.3
	net-libs/mbedtls:=
	sys-libs/ncurses:=
	virtual/libusb:=
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	dev-cpp/nlohmann_json
	dev-util/spirv-headers
	dev-libs/xbyak
	>=dev-libs/vulkan-memory-allocator-3.0.2_pre20230911
	dev-util/vulkan-headers
	dev-util/vulkan-utility-libraries
"
#BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/suyu-create_target_directory_groups.patch
	"${FILESDIR}"/suyu-system-libs.patch
)

src_unpack() {
	default

	declare -A libraries=(
		[sirit]=externals/sirit
		[tzdb_to_nx]=externals/nx_tzdb/tzdb_to_nx
	)

	for library in "${!libraries[@]}"; do
		local commit_variable="${library^^}_COMMIT_SHA"
		if test -d "${WORKDIR}/${library}"; then
			library_path="${WORKDIR}/${library}"
		elif test -d "${WORKDIR}/${library}-${!commit_variable}"; then
			library_path="${WORKDIR}/${library}-${!commit_variable}"
		else
			eerror "Unable to find folder for library ${library}"
			eerror "${WORKDIR}/${library}-${!commit_variable}"
			die
		fi

		mv "${library_path}"/* \
			"${S}/${libraries[$library]}/" || die
	done

	cp "${DISTDIR}"/${P}-compatibility_list.json \
		"${S}"/dist/compatibility_list/compatibility_list.json || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_SDL2=ON
		-DSUYU_USE_BUNDLED_SDL2=OFF
		-DSUYU_USE_EXTERNAL_SDL2=OFF
		-DENABLE_LIBUSB=ON
		-DENABLE_OPENGL=ON
		-DENABLE_OPENSSL=ON
		-DENABLE_QT=ON
		-DENABLE_QT6=ON
		-DENABLE_QT_TRANSLATION=ON
		-DENABLE_WEB_SERVICE=OFF
		-DSUYU_USE_BUNDLED_FFMPEG=OFF
		-DSUYU_USE_EXTERNAL_VULKAN_HEADERS=OFF
		-DSUYU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF
		-DSUYU_USE_FASTER_LD=OFF
		-DSUYU_USE_QT_MULTIMEDIA=ON
		-DSUYU_USE_QT_WEB_ENGINE=OFF
		-DENABLE_CUBE=ON
		-DUSE_DISCORD_PRESENCE=OFF
		-DSUYU_TESTS=$(usex test)
		-DSUYU_USE_PRECOMPILED_HEADERS=OFF
		-DSUYU_CRASH_DUMPS=OFF
		-DSUYU_CHECK_SUBMODULES=OFF
		-DSUYU_ENABLE_LTO=ON
		-DSUYU_DOWNLOAD_TIME_ZONE_DATA=OFF
		-DSUYU_ENABLE_PORTABLE=OFF
		-DUSE_CCACHE=OFF
		-DUSE_SYSTEM_MOLTENVK=ON
		-DSIRIT_USE_SYSTEM_SPIRV_HEADERS=ON
		-DTZDB2NX_ZONEINFO_DIR=/usr/share/zoneinfo
		-DTZDB2NX_VERSION=system
	)

	cmake_src_configure
}
