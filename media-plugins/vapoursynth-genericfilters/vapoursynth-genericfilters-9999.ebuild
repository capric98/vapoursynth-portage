# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs multilib

DESCRIPTION="Common image-processing filters for vapoursynth"
HOMEPAGE="https://github.com/chikuzen/GenericFilters"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/myrsloik/GenericFilters.git"
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/myrsloik/GenericFilters/archive/r${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="-noasm debug"

RDEPEND+="
	media-libs/vapoursynth
"
DEPEND="${RDEPEND}
"

S="${WORKDIR}/${P}/src"

src_prepare() {
	if use debug ; then
		myconf="${myconf} --enable-debug"
		sed -i 's/"$CC" "$LD" "$STRIP"/"$CC" "$LD"/' configure || die
	fi
	if use noasm ; then
		myconf="${myconf} --disable-simd"
	fi
	sed -i -e "s:CC=\"gcc\":CC=\"$(tc-getCC)\":" configure || die
	sed -i -e "s:LD=\"gcc\":LD=\"$(tc-getCC)\":" configure || die
	chmod +x configure
}

src_configure() {
	./configure ${myconf} --extra-cflags="${CFLAGS}" --extra-ldflags="${LDFLAGS}" || die
}

src_install() {
	exeinto /usr/$(get_libdir)/vapoursynth/
	doexe libgenericfilters.so
	dodoc ../readme.rst
}
