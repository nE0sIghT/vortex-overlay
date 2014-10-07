# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/wxGTK/wxGTK-3.0.1.1.ebuild,v 1.1 2014/10/06 01:06:16 leio Exp $

EAPI="5"

inherit eutils flag-o-matic multilib-minimal

DESCRIPTION="GTK+ version of wxWidgets, a cross-platform C++ GUI toolkit"
HOMEPAGE="http://wxwidgets.org/"

# we use the wxPython tarballs because they include the full wxGTK sources and
# docs, and are released more frequently than wxGTK.
SRC_URI="mirror://sourceforge/wxpython/wxPython-src-${PV}.tar.bz2
	doc? ( mirror://sourceforge/wxpython/wxPython-docs-${PV}.tar.bz2 )"

KEYWORDS="~amd64 ~x86"
IUSE="+X aqua doc debug gstreamer libnotify opengl sdl tiff webkit"

SLOT="3.0"

NATIVE_DEPEND="
	dev-libs/expat
	sdl?    ( media-libs/libsdl )
	X?  (
		>=dev-libs/glib-2.22:2
		media-libs/libpng:0=
		sys-libs/zlib
		virtual/jpeg
		>=x11-libs/gtk+-2.18:2
		x11-libs/gdk-pixbuf
		x11-libs/libSM
		x11-libs/libXxf86vm
		x11-libs/pango[X]
		gstreamer? (
			media-libs/gstreamer:0.10
			media-libs/gst-plugins-base:0.10 )
		libnotify? ( x11-libs/libnotify )
		opengl? ( virtual/opengl )
		tiff?   ( media-libs/tiff:0 )
		webkit? ( net-libs/webkit-gtk:2 )
	)
	aqua? (
		>=x11-libs/gtk+-2.4[aqua=]
		virtual/jpeg
		tiff?   ( media-libs/tiff:0 )
	)
"

RDEPEND="
	!amd64? ( ${NATIVE_DEPEND} )
	amd64? (
		abi_x86_64? ( ${NATIVE_DEPEND} )
		abi_x86_32? (
			|| (
				app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
				(
					dev-libs/expat[abi_x86_32]
					X? (
						>=dev-libs/glib-2.22:2[abi_x86_32]
						media-libs/libpng:0=[abi_x86_32]
						sys-libs/zlib[abi_x86_32]
						virtual/jpeg[abi_x86_32]
						tiff?   ( media-libs/tiff:0[abi_x86_32] )
					)
				)
			)
			sdl?    ( || (
					app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
					media-libs/libsdl[abi_x86_32]
			) )
			X?  (
				|| (
					app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
					(
						>=x11-libs/gtk+-2.18:2[abi_x86_32]
						x11-libs/gdk-pixbuf[abi_x86_32]
						x11-libs/pango[X,abi_x86_32]
						libnotify? ( x11-libs/libnotify )
					)
				)

				|| (
					app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
					(
						x11-libs/libSM[abi_x86_32]
						x11-libs/libXxf86vm[abi_x86_32]
					)
				)

				gstreamer? ( || (
					app-emulation/emul-linux-x86-medialibs[-abi_x86_32(-)]
					(
						media-libs/gstreamer:0.10[abi_x86_32]
						media-libs/gst-plugins-base:0.10[abi_x86_32]
					)
				) )
				opengl? ( || (
						app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
						virtual/opengl[abi_x86_32]
				) )
				webkit? ( net-libs/webkit-gtk:2[abi_x86_32] )
			)
			aqua? (
				|| (
					app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
					>=x11-libs/gtk+-2.4[abi_x86_32,aqua=]
				)

				|| (
					app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
					(
						virtual/jpeg[abi_x86_32]
						tiff?   ( media-libs/tiff:0[abi_x86_32] )
					)
				)
			)
		)
	)
"

DEPEND="${RDEPEND}
	!amd64? ( virtual/glu )
	amd64? (
		abi_x86_64? ( virtual/glu )
		abi_x86_32? (
		    opengl? ( || (
			app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
			virtual/glu[abi_x86_32]
		    ) )
		)
	)
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	X?  (
		x11-proto/xproto[${MULTILIB_USEDEP}]
		x11-proto/xineramaproto[${MULTILIB_USEDEP}]
		x11-proto/xf86vidmodeproto[${MULTILIB_USEDEP}]
	)"

PDEPEND=">=app-admin/eselect-wxwidgets-20131230"

LICENSE="wxWinLL-3
		GPL-2
		doc?	( wxWinFDL-3 )"

S="${WORKDIR}/wxPython-src-${PV}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.0.0.0-collision.patch
	epatch_user
}

multilib_src_configure() {
	local myconf

	# X independent options
	myconf="
			--with-zlib=sys
			--with-expat=sys
			--enable-compat28
			$(use_with sdl)"

	# debug in >=2.9
	# there is no longer separate debug libraries (gtk2ud)
	# wxDEBUG_LEVEL=1 is the default and we will leave it enabled
	# wxDEBUG_LEVEL=2 enables assertions that have expensive runtime costs.
	# apps can disable these features by building w/ -NDEBUG or wxDEBUG_LEVEL_0.
	# http://docs.wxwidgets.org/3.0/overview_debugging.html
	# http://groups.google.com/group/wx-dev/browse_thread/thread/c3c7e78d63d7777f/05dee25410052d9c
	use debug \
		&& myconf="${myconf} --enable-debug=max"

	# wxGTK options
	#   --enable-graphics_ctx - needed for webkit, editra
	#   --without-gnomevfs - bug #203389
	use X && \
		myconf="${myconf}
			--enable-graphics_ctx
			--with-gtkprint
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--without-gnomevfs
			$(use_enable gstreamer mediactrl)
			$(use_enable webkit webview)
			$(use_with libnotify)
			$(use_with opengl)
			$(use_with tiff libtiff sys)"

	use aqua && \
		myconf="${myconf}
			--enable-graphics_ctx
			--enable-gui
			--with-libpng=sys
			--with-libxpm=sys
			--with-libjpeg=sys
			--with-mac
			--with-opengl"
			# cocoa toolkit seems to be broken

	# wxBase options
	if use !X && use !aqua ; then
		myconf="${myconf}
			--disable-gui"
	fi

	ECONF_SOURCE="${S}" econf ${myconf}
}

multilib_src_compile() {
	default
}

multilib_src_install() {
	default

	if multilib_is_native_abi; then
		# Stray windows locale file, causes collisions
		local wxmsw="${ED}usr/share/locale/it/LC_MESSAGES/wxmsw.mo"
		[[ -e ${wxmsw} ]] && rm "${wxmsw}"
	fi 
}

multilib_src_install_all() {
	cd "${S}"/docs
	dodoc changes.txt readme.txt
	newdoc base/readme.txt base_readme.txt
	newdoc gtk/readme.txt gtk_readme.txt

	if use doc; then
		dohtml -r "${S}"/docs/doxygen/out/html/*
	fi
}

pkg_postinst() {
	has_version app-admin/eselect-wxwidgets \
		&& eselect wxwidgets update
}

pkg_postrm() {
	has_version app-admin/eselect-wxwidgets \
		&& eselect wxwidgets update
}
