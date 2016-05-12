# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Fast JSON parser/generator for C++"
HOMEPAGE="https://github.com/miloyip/rapidjson"
EGIT_REPO_URI="https://github.com/miloyip/rapidjson.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

DEPEND="doc? ( app-doc/doxygen[dot] )
	test? (
		dev-cpp/gtest
		dev-util/valgrind
	)"
RDEPEND=""

DOCS="readme.md CHANGELOG.md"

src_prepare() {
	rm -r thirdparty || die
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DRAPIDJSON_BUILD_TESTS="$(usex test)"
		-DRAPIDJSON_BUILD_DOC="$(usex doc)"
		-DRAPIDJSON_BUILD_EXAMPLES="$(usex examples)"
	)
	cmake-utils_src_configure
}
