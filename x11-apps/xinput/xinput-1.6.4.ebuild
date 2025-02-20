# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-3

DESCRIPTION="Utility to set XInput device parameters"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND=">=x11-libs/libX11-1.3
	x11-libs/libXext
	>=x11-libs/libXi-1.5.99.1
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
