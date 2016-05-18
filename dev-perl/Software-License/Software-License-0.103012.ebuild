# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.103012
inherit perl-module

DESCRIPTION="Provide templated software licenses"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Data-Section
	dev-perl/Text-Template
	dev-perl/Try-Tiny
	virtual/perl-Encode
"

SRC_TEST="do"
