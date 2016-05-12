# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 qmake-utils toolchain-funcs

DESCRIPTION="Simple way to communicate and nothing extra."
HOMEPAGE="https://icq.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mailru/icqdesktop.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-db/gigabase
	>=dev-libs/rapidjson-9999
	dev-qt/qtcore:5
	media-video/rtmpdump
"
DEPEND="${RDEPEND}"

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary && $(tc-getCC) == *gcc* ]]; then
		if [[ $(gcc-major-version) -lt 5 ]] ; then
			die "${PN} does not compile with gcc less than 5"
		fi
	fi
}

src_prepare() {
	rm -r external/ || die
	cp "${FILESDIR}/${PN}.pro" "${S}" || die

	eapply "${FILESDIR}"/0001-Fix-compilation-with-boost-1.56.patch
	eapply "${FILESDIR}"/0001-Fix-headers-path.patch
	eapply "${FILESDIR}"/0001-Fix-external-headers-path.patch
	eapply "${FILESDIR}"/0001-Removed-static-links.patch
	eapply "${FILESDIR}"/0002-Fixed-corelib-path.patch
	eapply "${FILESDIR}"/0003-corelib-add-boost_filesystem-link.patch
	eapply "${FILESDIR}"/0004-gui-added-missing-files.patch
	eapply_user

	find . -name "*.cpp" -o -name "*.h" -exec \
		sed -i \
			-e 's:#include ".*/external/\(.*\.h\):#include "\1:g' \
			{} \;
}

src_configure() {
	for file in gui/translations/*.ts; do
		"$(qt5_get_bindir)"/lrelease "${file}" || die
	done

	"$(qt5_get_bindir)"/rcc gui/resource.qrc -o gui/qresource -binary || die

	eqmake5 "${PN}".pro
}
