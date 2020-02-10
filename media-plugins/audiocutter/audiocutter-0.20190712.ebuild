# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit python-single-r1 git-r3

DESCRIPTION="A tool to cut audio and generate associated chapters/qpfiles for vapoursynth"
HOMEPAGE="https://github.com/AzraelNewtype/audiocutter"

EGIT_REPO_URI="https://github.com/AzraelNewtype/audiocutter.git"
EGIT_COMMIT="c518e30f95405d80d284f6cab1db27cc0c246ddc"
KEYWORDS="~amd64 ~x86"

LICENSE=""
SLOT="0"
IUSE=""

RDEPEND+="
	media-libs/vapoursynth[${PYTHON_SINGLE_USEDEP}]
	media-video/mkvtoolnix
"
DEPEND="${RDEPEND}"

DOCS=( "README.md" )


src_install(){
	python_domodule audiocutter.py
}
