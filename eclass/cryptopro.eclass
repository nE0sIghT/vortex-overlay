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
	x86? ( ${PN}-${PV}-4.i486.rpm )
"

LICENSE="Crypto-Pro"
S="${WORKDIR}"

RESTRICT="fetch mirror strip"

# required: type id name
# optional: connect level
cryptopro_add_hardware() {
	if [ ${#@} -lt 3 ]; then
		eerror "Too few arguments"
		die
	fi

	local name_cp1251=`echo "${3}" | iconv -f utf-8 -t cp1251`
	local connect=Default

	if [ -n "${4}" ]; then
		connect="${4}"
	fi

	if [ -n "${5}" ]; then
		local level="-level ${5}"
		local level_text=" at level ${5}"
	fi

	ebegin "Adding ${1} hardware ${2}: ${3}<${connect}>${level_text}"
	eval cpconfig -hardware "${1}" -add "${2}" -connect "${connect}" -name \""${name_cp1251}"\" ${level} > /dev/null
	eend $?
}

# type id
cryptopro_remove_hardware() {
	if [ ${#@} -lt 2 ]; then
		eerror "Too few arguments"
		die
	fi

	ebegin "Removing ${1} hardware ${2}"
	cpconfig -hardware "${1}" -del "${2}" > /dev/null
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
	cpconfig -defprov -setdef -provtype "${2}" \
		 -provname "${1}"
	cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add string 'Image Path' /usr/$(get_libdir)/"${3}"
	cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add string 'Function Table Name' "${4}"
	cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}"\
		-add long Type "${2}"

	if [ -n "${5}" ]; then
		cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}"\
			-add string 'Base CP Module Name' "${5}"
	fi
	if [ -n "${6}" ]; then
		cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}"\
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
	cpconfig -ini "\\cryptography\\Defaults\\Provider\\${1}" -delsection
        eend $?
}

# path type key value
cryptopro_add_ini() {
	if [ "${#@}" -lt 4 ]; then
		eerror "Too few arguments"
		die
	fi

	ebegin "Adding config $(_cryptopro_escape ${1}): ${2} ${3} ${4}"
	cpconfig -ini "${1}" -add "${2}" "${3}" "${4}"
	eend $?
}

# path name
cryptopro_register_lib() {
	if [ "${#@}" -lt 2 ]; then
		eerror "Too few arguments"
		die
	fi

	if [ ! -e "${1}"/"${2}" ]; then
		die "Trying to register non existing library ${1}/${2}"
	fi

	cryptopro_add_ini '\config\apppath' string "${2}" "${1}/${2}"
}

cryptopro_get_config() {
	if use amd64; then
		echo config64.ini
	else
		echo config.ini
	fi
}

cryptopro_pkg_nofetch() {
	if [ -z "${CRYPTOPRO_FETCH}" ]; then
		local CRYPTOPRO_FETCH="https://www.cryptopro.ru/"
	fi

	eerror
	eerror " Due to restrictions, we cannot fetch the"
	eerror " distributables automagically."
	eerror
	eerror " 1. Visit ${CRYPTOPRO_FETCH}"
	eerror " 2. Download proper *linux_*.tar.gz archive"
	eerror " 3. Unpack following file to \$DISTDIR:"
	eerror "    ${SRC_URI}"
	eerror
	eerror " Run emerge on this package again to complete"
	eerror
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
		local exepath=/opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"
		exeinto "${exepath}"

		for binary in ${CRYPTOPRO_BINARIES[@]}; do
			doexe opt/cprocsp/bin/"${CRYPTOPRO_ARCH}"/"${binary}"
			dosym "${exepath}"/"${binary}" /usr/bin/"${binary}"
		done
	fi

	if [ -n "${CRYPTOPRO_SBINARIES}" ]; then
		local exepath=/opt/cprocsp/sbin/"${CRYPTOPRO_ARCH}"
		exeinto "${exepath}"

		for binary in ${CRYPTOPRO_SBINARIES[@]}; do
			doexe opt/cprocsp/sbin/"${CRYPTOPRO_ARCH}"/"${binary}"
			dosym "${exepath}"/"${binary}" /usr/sbin/"${binary}"
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
			cryptopro_register_lib /usr/"$(get_libdir)" "${lib}"
		done
	fi
}

cryptopro_pkg_prerm() {
	if [ -n "${CRYPTOPRO_REGISTER_LIBS}" ]; then
		einfo "Deregistering libs with cpconfig"
		for lib in "${CRYPTOPRO_REGISTER_LIBS[@]}"; do
			ebegin "${lib}"
			cpconfig -ini "\\config\\apppath\\${lib}" -delparam
			eend $?
		done
	fi

	if [ -n "${CRYPTOPRO_UNSET_PARAMS}" ]; then
		einfo "Removing parameters with cpconfig"
		for param in "${CRYPTOPRO_UNSET_PARAMS[@]}"; do
			ebegin "$(_cryptopro_escape ${param})"
			cpconfig -ini "${param}" -delparam
			eend $?
		done
	fi

	if [ -n "${CRYPTOPRO_UNSET_SECTIONS}" ]; then
		einfo "Removing sections with cpconfig"
		for section in "${CRYPTOPRO_UNSET_SECTIONS[@]}"; do
			ebegin "$(_cryptopro_escape ${section})"
			cpconfig -ini "${section}" -delsection
			eend $?
		done
	fi
}

_cryptopro_escape() {
	echo "$*" | sed 's#\\#\\\\#g'
}
