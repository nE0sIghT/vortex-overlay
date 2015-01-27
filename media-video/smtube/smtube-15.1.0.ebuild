# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/smtube/smtube-1.0.ebuild,v 1.1 2012/03/03 14:15:10 pesa Exp $

EAPI=4
LANGS="es ja it"
LANGSLONG="ru_RU"

inherit eutils qt4-r2

# regular upstream release
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"

IUSE=""
DESCRIPTION="A youtube search and play add-on for smplayer."
HOMEPAGE="http://smplayer.sourceforge.net/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-qt/qtgui:4"
RDEPEND="${DEPEND}"

src_prepare() {
	# Upstream Makefile sucks
	sed -i -e "/^PREFIX=/s:/usr/local:/usr:" \
		-e "/^DOC_PATH=/s:smtube:${PF}:" \
		-e '/\.\/get_svn_revision\.sh/,+2c\
	cd src && $(DEFS) $(MAKE)' \
		"${S}"/Makefile || die "sed failed"
}

src_configure() {
	cd "${S}"/src
	echo "#define SVN_REVISION \"SVN-${PV} (Gentoo)\"" > svn_revision.h
	eqmake4
}

gen_translation() {
	ebegin "Generating $1 translation"
	lrelease ${PN}_${1}.ts
	eend $? || die "failed to generate $1 translation"
}

src_compile() {
	emake

	# Generate translations
	cd "${S}"/src/translations
	local lang= nolangs= x=
	for lang in ${LINGUAS}; do
		if has ${lang} ${LANGS}; then
			gen_translation ${lang}
			continue
		elif [[ " ${LANGSLONG} " == *" ${lang}_"* ]]; then
			for x in ${LANGSLONG}; do
				if [[ "${lang}" == "${x%_*}" ]]; then
					gen_translation ${x}
					continue 2
				fi
			done
		fi
		nolangs="${nolangs} ${lang}"
	done
	[[ -n ${nolangs} ]] && ewarn "Sorry, but ${PN} does not support the LINGUAS:" ${nolangs}
	# install fails when no translation is present (bug 244370)
	[[ -z $(ls *.qm 2>/dev/null) ]] && gen_translation en
}

src_install() {
	# remove unneeded copies of GPL
	rm -f Copying.txt Copying_BSD.txt

	emake DESTDIR="${D}" install
}
