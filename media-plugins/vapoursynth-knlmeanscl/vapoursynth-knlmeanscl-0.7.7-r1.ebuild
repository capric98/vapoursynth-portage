# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib eutils

DESCRIPTION="An optimized pixelwise OpenCL implementation of the Non-local means denoising algorithm"
HOMEPAGE="https://github.com/Khanattila/KNLMeansCL"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Khanattila/KNLMeansCL.git"
	KEYWORDS=""
else
	inherit vcs-snapshot
	SRC_URI="https://github.com/Khanattila/KNLMeansCL/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="LGPL-3"
SLOT="0/0.7"
CARDS=( nvidia )
IUSE="${CARDS[@]/#/video_cards_}"

RDEPEND+="
	media-libs/vapoursynth
	virtual/opencl
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers
		dev-libs/ocl-icd
		)
"
DEPEND="${RDEPEND}
"

src_prepare() {
	chmod +x configure
	default
}

src_configure() {
	sed -i -e "s:CXX=\"g++\":CXX=\"$(tc-getCXX)\":" configure || die
	sed -i -e "s:LD=\"g++\":LD=\"$(tc-getCXX)\":" configure || die

	./configure \
		--install="${ED}/usr/$(get_libdir)/vapoursynth/" \
		--extra-cxxflags="${CXXFLAGS}" --extra-ldflags="${LDFLAGS}" || die "configure failed"
}

src_install() {
	exeinto "/usr/$(get_libdir)/vapoursynth/"
	doexe libknlmeanscl.so
}