# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Next generation Debian package upload tool"
HOMEPAGE="https://people.debian.org/~paultag/dput-ng/"
SRC_URI="mirror://debian/pool/main/d/${PN}/${PN}_${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/asciidoc
	dev-python/python-debian[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-util/distro-info[python,${PYTHON_USEDEP}]
"

IUSE=""

S="${WORKDIR}/${PN/-/}"

DPUT_BINARIES=(
	dcut
	dirt
	dput
)

DPUT_ETC=(
	metas
	profiles
)

DPUT_SHARE=(
	codenames
	commands
	hooks
	interfaces
	schemas
	uploaders
)

src_compile() {
	distutils-r1_src_compile

	mkdir "${S}"/man
	for file in "${S}"/docs/man/*.man; do
		a2x --doctype manpage \
			--format manpage \
			-D "${S}"/man \
			"${file}"
	done
}

src_install() {
	distutils-r1_src_install

	for binary in ${DPUT_BINARIES[@]}; do
		dobin "${S}"/bin/"${binary}"
	done
	python_fix_shebang "${D}"usr/bin

	insinto /etc/dput.d
	for dir in ${DPUT_ETC[@]}; do
		doins -r "${S}/skel/${dir}"
	done

	insinto /usr/share/"${PN}"
	for dir in ${DPUT_SHARE[@]}; do
		doins -r "${S}/skel/${dir}"
	done

	insinto /usr/share/man/man5
	doins man/dput.cf.5
	rm "${S}"/man/dput.cf.5 || die

	for file in "${S}"/man/*; do
		doman "${file}"
	done

	newbashcomp debian/"${PN}".bash-completion dput
}
