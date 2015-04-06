# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

# @ECLASS: cryptopro.eclass
# @MAINTAINER:
# Yuri Konotopov <ykonotopov@gmail.com>
# @BLURB: wrapper cryptopro packages
# @DESCRIPTION:
#
# pkg_nofetch pkg_setup src_install
#


case ${EAPI:-0} in
	5) ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac


inherit rpm

EXPORT_FUNCTIONS pkg_nofetch pkg_setup src_install

HOMEPAGE="https://www.cryptopro.ru/"
SRC_URI="
	amd64? ( ${PN}-64-${PV}-4.x86_64.rpm )
"
#	x86? ( ${PN}-${PV}-4.i486.rpm )

LICENSE="Crypto-Pro"
S="${WORKDIR}"

RESTRICT="fetch mirror"

cryptopro_pkg_nofetch() {
	if [ -z "${CRYPTOPRO_FETCH}" ]; then
		local CRYPTOPRO_FETCH="https://www.cryptopro.ru/"
	fi

	einfo
        einfo " Due to restrictions, we cannot fetch the"
        einfo " distributables automagically."
        einfo
        einfo " 1. Visit ${CRYPTOPRO_FETCH}"
        einfo " 2. Download cades_linux_*.tar.gz"
        einfo " 3. Unpack following file to \$DISTDIR:"
        einfo "    ${SRC_URI}"
        einfo
        einfo " Run emerge on this package again to complete"
        einfo
}

cryptopro_pkg_setup() {
	if use amd64; then
                CRYPTOPRO_ARCH="amd64"
        else
                CRYPTOPRO_ARCH="ia32"
        fi
}

cryptopro_src_install() {
	if [ -n "${CRYPTOPRO_BINARIES}" ]; then
		exeinto "/opt/cprocsp/bin/${arch}"

		for binary in ${CRYPTOPRO_BINARIES[@]}; do
			doexe opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"/"${binary}"
		done
	fi

	if [ -d opt/cprocsp/lib/"${CRYPTOPRO_ARCH}" ]; then
	        insinto /usr/$(get_libdir)

	        for lib in opt/cprocsp/lib/"${CRYPTOPRO_ARCH}"/lib*.so*; do
	    		if [ -e ${lib} ]; then
		                if [ -L ${lib} ]; then
		                        doins "${lib}"
		                else
		                    dolib.so "${lib}"
		                fi
		        fi
	        done
	fi

        insinto "/opt/cprocsp/lib"
        doins -r opt/cprocsp/lib/hashes
}
