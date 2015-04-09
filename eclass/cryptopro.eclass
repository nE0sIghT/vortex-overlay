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

EXPORT_FUNCTIONS pkg_nofetch pkg_setup src_install pkg_postinst pkg_prerm

HOMEPAGE="https://www.cryptopro.ru/"
SRC_URI="
	amd64? ( ${PN}-64-${PV}-4.x86_64.rpm )
"
#	x86? ( ${PN}-${PV}-4.i486.rpm )

LICENSE="Crypto-Pro"
S="${WORKDIR}"

RESTRICT="fetch mirror strip"

cryptopro_unicode() {
	"$@" | iconv -f cp1251 -t utf-8
}

# type id name level
cryptopro_add_hardware() {
	if [ ${#@} -lt 3 ]; then
		eerror "Too few arguments"
		die
	fi

	local name_cp1251=`echo "${3}" | iconv -f utf-8 -t cp1251`
	if [ -n "${4}" ]; then
		local level="-level ${4}"
		local level_text=" at level ${4}"
	fi

	ebegin "Adding ${1} hardware ${2}: ${3}${level_text}"
	eval "${CPCONFIG}" -hardware "${1}" -add "${2}" -name "${name_cp1251}" ${level} > /dev/null
	eend $?
}

# type id
cryptopro_remove_hardware() {
	if [ ${#@} -lt 2 ]; then
		eerror "Too few arguments"
		die
	fi

	ebegin "Removing ${1} hardware ${2}"
	"${CPCONFIG}" -hardware "${1}" -del "${2}" > /dev/null
	eend $?
}

# required: name type image function
# optional: base_cp base_function
cryptopro_add_provider() {
	if [ "${#@}" -lt 4 ]; then
		eerror "Too few arguments"
		die
	fi

	ebegin "Adding ${1} provider"
	"${CPCONFIG}" -defprov -setdef -provtype "${2}" \
		 -provname "${1}"
	"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add string 'Image Path' /usr/$(get_libdir)/"${3}"
	"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add string 'Function Table Name' "${4}"
	"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add long Type "${2}"

	if [ -n "${5}" ]; then
		"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}"\
			-add string 'Base CP Module Name' "${5}"
	fi
	if [ -n "${6}" ]; then
		"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}"\
			-add string 'Base Function Table Name' "${6}"
	fi
        eend 0
}

# name
cryptopro_remove_provider() {
	if [ "${#@}" -lt 1 ]; then
		eerror "Too few arguments"
		die
	fi

	ebegin "Removing ${1} provider"
	"${CPCONFIG}" -ini "\\cryptography\\Defaults\\Provider\\${1}" -delsection
        eend $?
}

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

	CPCONFIG=/opt/cprocsp/sbin/"${CRYPTOPRO_ARCH}"/cpconfig
}

cryptopro_src_install() {
	if [ -n "${CRYPTOPRO_BINARIES}" ]; then
		exeinto /opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"

		for binary in ${CRYPTOPRO_BINARIES[@]}; do
			doexe opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"/"${binary}"
		done
	fi

	if [ -n "${CRYPTOPRO_SBINARIES}" ]; then
		exeinto /opt/cprocsp/sbin/"${CRYPTOPRO_ARCH}"

		for binary in ${CRYPTOPRO_SBINARIES[@]}; do
			doexe opt/cprocsp/sbin/"${CRYPTOPRO_ARCH}"/"${binary}"
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

cryptopro_pkg_postinst() {
	if [ -n "${CRYPTOPRO_REGISTER_LIBS}" ]; then
		einfo "Registering libs with cpconfig"
		for lib in "${CRYPTOPRO_REGISTER_LIBS[@]}"; do
			ebegin "${lib}"
			"${CPCONFIG}" -ini '\config\apppath' -add string "${lib}"\
				/usr/"$(get_libdir)"/"${lib}"
			eend $?
		done
	fi
}

cryptopro_pkg_prerm() {
	if [ -n "${CRYPTOPRO_REGISTER_LIBS}" ]; then
		einfo "Deregistering libs with cpconfig"
		for lib in "${CRYPTOPRO_REGISTER_LIBS[@]}"; do
		ebegin "${lib}"
		"${CPCONFIG}" -ini "\\config\\apppath\\${lib}" -delparam
		eend $?
		done
	fi

	if [ -n "${CRYPTOPRO_UNSET_PARAMS}" ]; then
		einfo "Removing parameters with cpconfig"
		for param in "${CRYPTOPRO_UNSET_PARAMS[@]}"; do
			ebegin "${param}"
			"${CPCONFIG}" -ini "${param}" -delparam
			eend $?
		done
	fi

	if [ -n "${CRYPTOPRO_UNSET_SECTIONS}" ]; then
		einfo "Removing sections with cpconfig"
		for section in "${CRYPTOPRO_UNSET_SECTIONS[@]}"; do
			ebegin "${section}"
			"${CPCONFIG}" -ini "${section}" -delsection
			eend $?
		done
	fi
}
