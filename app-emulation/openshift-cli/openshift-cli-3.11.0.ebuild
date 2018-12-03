# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/openshift/origin"

inherit bash-completion-r1 golang-build golang-vcs-snapshot

DESCRIPTION="OpenShift Command-Line Interface"
HOMEPAGE="https://www.openshift.org"
SRC_URI="https://github.com/openshift/origin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion"

RDEPEND="bash-completion? ( >=app-shells/bash-completion-2.3-r1 )"

src_compile() {
	EGO_PN="${EGO_PN}/cmd/oc" golang-build_src_compile
}

src_install() {
	dobin oc

	pushd src/${EGO_PN} || die
	doman docs/man/man1/oc*
	use bash-completion && dobashcomp contrib/completions/bash/oc
	popd || die
}
