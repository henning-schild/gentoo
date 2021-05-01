# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Tool for performing actions on an Active Directory domain"
HOMEPAGE="https://www.freedesktop.org/software/realmd/adcli/adcli.html"
SRC_URI="https://gitlab.freedesktop.org/realmd/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	app-crypt/mit-krb5
	net-nds/openldap[sasl]"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? (
		dev-libs/libxslt
		app-text/xmlto
	)"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable doc)
}
