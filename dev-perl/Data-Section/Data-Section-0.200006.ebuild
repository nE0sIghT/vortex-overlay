# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=0.200006
inherit perl-module

DESCRIPTION="Read multiple hunks of data out of your DATA section"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-perl/Test-FailWarnings )"
RDEPEND="
	dev-perl/MRO-Compat
	dev-perl/Sub-Exporter
	virtual/perl-Encode
"

SRC_TEST="do"
