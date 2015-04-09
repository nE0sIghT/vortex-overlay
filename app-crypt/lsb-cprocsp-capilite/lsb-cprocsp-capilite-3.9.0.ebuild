# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/adobe-flash/adobe-flash-11.2.202.451.ebuild,v 1.3 2015/03/13 14:10:11 ago Exp $

EAPI=5
inherit cryptopro

DESCRIPTION="CryptoAPI lite."

IUSE=""
SLOT="0"

KEYWORDS="-* ~amd64"

DEPEND="app-crypt/lsb-cprocsp-rdr"
RDEPEND="${DEPEND}"

CRYPTOPRO_BINARIES=(
	certmgr
	cryptcp
	csptestf
	der2xer
	inittst
)

CRYPTOPRO_REGISTER_LIBS=( libpkivalidator.so )
CRYPTOPRO_UNSET_PARAMS=(
	'\config\policy\OIDs\{A4CC781E-04E9-425C-AAFD-1D74DA8DFAF6}'
	'\config\policy\OIDs\{AF74EE92-A059-492F-9B4B-EAD239B22A1B}'
	'\config\policy\OIDs\{B52FF66F-13A5-402C-B958-A3A6B5300FB6}'
	'\config\policy\OIDs\4'
)

pkg_postinst() {
	cryptopro_pkg_postinst

	echo
	ebegin "Adding cpconfig strings"
	"${CPCONFIG}" -ini '\config\policy\OIDs' \
	    -add string '{A4CC781E-04E9-425C-AAFD-1D74DA8DFAF6}' 'libpkivalidator.so OCSPSigningImpl'
	"${CPCONFIG}" -ini '\config\policy\OIDs' \
	    -add string '{AF74EE92-A059-492F-9B4B-EAD239B22A1B}' 'libpkivalidator.so TimestampSigningImpl'
	"${CPCONFIG}" -ini '\config\policy\OIDs' \
	    -add string '{B52FF66F-13A5-402C-B958-A3A6B5300FB6}' 'libpkivalidator.so SignatureImpl'
	"${CPCONFIG}" -ini '\config\policy\OIDs' \
	    -add string '4' 'libpkivalidator.so SSLImpl'
	eend 0
}
