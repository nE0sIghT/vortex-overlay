# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeprint/libgnomeprint-2.18.8.ebuild,v 1.14 2014/04/29 11:47:52 polynomial-c Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="Printer handling for Gnome"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2.2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="cups doc"

RDEPEND=">=dev-libs/glib-2[${MULTILIB_USEDEP}]
	>=media-libs/libart_lgpl-2.3.7[${MULTILIB_USEDEP}]
	>=x11-libs/pango-1.5[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.4.23[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-1[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.0.5[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	cups? (
		>=net-print/cups-1.1.20[${MULTILIB_USEDEP}]
		>=net-print/libgnomecups-0.2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	sys-devel/flex
	sys-devel/bison
	doc? (
		~app-text/docbook-xml-dtd-4.1.2
		>=dev-util/gtk-doc-0.9 )"

DOCS="AUTHORS BUGS ChangeLog* NEWS README"

pkg_setup() {
	# Disable papi support until papi is in portage; avoids automagic
	# dependencies on an untracked library.
	G2CONF="${G2CONF} $(use_with cups) --without-papi --disable-static"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-stdio-include.patch \
		"${FILESDIR}"/${P}-freetype-2.5.1.patch \
		"${FILESDIR}"/${P}-bison3.patch
	eautoreconf
	gnome2_src_prepare

	# Drop DEPRECATED flags, bug #384807
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED::g' \
		configure.in configure || die
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' \
		libgnomeprint/ttsubset/Makefile.am \
		libgnomeprint/ttsubset/Makefile.in || die
}

multilib_src_configure() {
	ECONF_SOURCE=${S} gnome2_src_configure
}
