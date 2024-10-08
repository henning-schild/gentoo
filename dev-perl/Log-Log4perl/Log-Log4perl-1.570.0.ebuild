# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=1.57
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Log4j implementation for Perl"
HOMEPAGE="https://github.com/mschilli/log4perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=virtual/perl-File-Path-2.70.0
	>=virtual/perl-File-Spec-0.820.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.450.0 )
"
