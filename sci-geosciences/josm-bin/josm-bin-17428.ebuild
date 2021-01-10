# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2 desktop

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="https://josm.openstreetmap.de/"

SRC_URI="https://josm.openstreetmap.de/download/josm-snapshot-${PV}.jar"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

IUSE=""

S=${WORKDIR}

src_unpack() {
	default
	cp "${DISTDIR}/${A}" "${S}/${PN}.jar"
}

src_install() {
	java-pkg_dojar ${PN}.jar || die "java-pkg_dojar failed"
	java-pkg_dolauncher "${PN}" --jar ${PN}.jar || die "java-pkg_dolauncher failed"

	local icon_size
	for icon_size in 16 32 48; do
		newicon -s "${icon_size}" -t "hicolor" \
			"images/logo_${icon_size}x${icon_size}x32.png" ${PN}.png
		newicon -s "${icon_size}" -t "locolor" \
			"images/logo_${icon_size}x${icon_size}x8.png" ${PN}.png
	done
	make_desktop_entry ${PN} "Java OpenStreetMap Editor" ${PN} "Utility;Science;Geoscience"
}
