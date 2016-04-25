# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 prefix systemd user

MY_P="apache-${P}-src"

DESCRIPTION="Tomcat Servlet-3.1/JSP-2.3 Container"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-8/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="8"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="extra-webapps"

RESTRICT="test" # can we run them on a production system?

ECJ_SLOT="4.5"
SAPI_SLOT="3.1"

COMMON_DEP="dev-java/eclipse-ecj:${ECJ_SLOT}
	dev-java/tomcat-servlet-api:${SAPI_SLOT}"
RDEPEND="${COMMON_DEP}
	!<dev-java/tomcat-native-1.1.24
	sys-apps/gentoo-functions
	>=virtual/jre-1.7"
DEPEND="${COMMON_DEP}
	app-admin/pwgen
	>=virtual/jdk-1.7
	test? (
		>=dev-java/ant-junit-1.9:0
		dev-java/easymock:3.2
	)"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

java_prepare() {
	find -name '*.jar' -type f -delete -print || die

	# Remove bundled servlet-api
	rm -rv java/javax/{el,servlet} || die

	epatch "${FILESDIR}/${P}-build.xml.patch"

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_BUILD_TARGET="deploy"
EANT_GENTOO_CLASSPATH="eclipse-ecj-${ECJ_SLOT},tomcat-servlet-api-${SAPI_SLOT}"
EANT_TEST_GENTOO_CLASSPATH="easymock-3.2"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/output/classes"
EANT_NEEDS_TOOLS="true"
EANT_EXTRA_ARGS="-Dversion=${PV}-gentoo -Dversion.number=${PV} -Dcompile.debug=false"

# revisions of the scripts
IM_REV="-r2"
INIT_REV="-r2"

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant-core ant.jar)"
	java-pkg-2_src_compile
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	local dest="/usr/share/${PN}-${SLOT}"

	java-pkg_jarinto "${dest}"/bin
	java-pkg_dojar output/build/bin/*.jar
	exeinto "${dest}"/bin
	doexe output/build/bin/*.sh

	java-pkg_jarinto "${dest}"/lib
	java-pkg_dojar output/build/lib/*.jar

	dodoc RELEASE-NOTES RUNNING.txt
	use doc && java-pkg_dojavadoc output/dist/webapps/docs/api
	use source && java-pkg_dosrc java/*

	### Webapps ###

	# add missing docBase
	local apps="host-manager manager"
	for app in ${apps}; do
		sed -i -e "s|=\"true\" >|=\"true\" docBase=\"\$\{catalina.home\}/webapps/${app}\" >|" \
			output/build/webapps/${app}/META-INF/context.xml || die
	done

	insinto "${dest}"/webapps
	doins -r output/build/webapps/{host-manager,manager,ROOT}
	use extra-webapps && doins -r output/build/webapps/{docs,examples}

	### Config ###

	# create "logs" directory in $CATALINA_BASE
	# and set correct perms, see #458890
	dodir "${dest}"/logs
	fperms 0750 "${dest}"/logs

	# replace the default pw with a random one, see #92281
	local randpw="$(pwgen -s -B 15 1)"
	sed -i -e "s|SHUTDOWN|${randpw}|" output/build/conf/server.xml || die

	# prepend gentoo.classpath to common.loader, see #453212
	sed -i -e 's/^common\.loader=/\0${gentoo.classpath},/' output/build/conf/catalina.properties || die

	### rc ###

	cp "${FILESDIR}"/${PN}{.conf,${INIT_REV}.init,-server,-tmpfiles.d,-${SLOT}.service,-named-${SLOT}.service} "${T}" || die
	eprefixify "${T}"/${PN}{.conf,${INIT_REV}.init,-server,-tmpfiles.d,-${SLOT}.service,-named-${SLOT}.service}
	sed -i -e "s|@SLOT@|${SLOT}|g" "${T}"/${PN}{.conf,${INIT_REV}.init,-server,-tmpfiles.d,-${SLOT}.service,-named-${SLOT}.service} || die

	insinto "/etc/tomcat-${SLOT}"
	doins -r output/build/conf/*
	doins "${T}"/tomcat.conf
	dosym /etc/tomcat-${SLOT} "${dest}"/conf

	newinitd "${T}"/tomcat${INIT_REV}.init tomcat-${SLOT}.init

	exeinto /usr/libexec/tomcat
	newexe "${T}"/tomcat-server server-${SLOT}

	dodir /var/lib/tomcats
	fowners tomcat:tomcat /var/lib/tomcats
	dodir /var/lib/tomcats/${PN}-${SLOT}

	systemd_newunit "${T}"/${PN}-${SLOT}.service ${PN}-${SLOT}.service
	systemd_newunit "${T}"/${PN}-named-${SLOT}.service ${PN}-${SLOT}@.service
	systemd_newtmpfilesd "${T}"/${PN}-tmpfiles.d ${PN}-${SLOT}.conf
}

pkg_postinst() {
	elog "New ebuilds of Tomcat support running multiple instances. If you used prior version"
	elog "of Tomcat (<8.0.33-r1), you have to migrate your existing instance to work with new Tomcat."
	elog "You can find more information at https://wiki.gentoo.org/wiki/Apache_Tomcat"
	echo

	elog "To create temp directories you must restart system."
	elog "Alternatively for systemd you can run"
	elog "        systemd-tmpfiles --create"
	elog "without reboot."
	echo

	ewarn "tomcat-dbcp.jar is not built at this time. Please fetch jar"
	ewarn "from upstream binary if you need it. Gentoo Bug # 144276"
}
