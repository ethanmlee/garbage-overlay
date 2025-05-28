EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )
inherit git-r3 distutils-r1

DESCRIPTION="A fork of epr, a CLI Ebook Reader"
HOMEPAGE="https://github.com/wustho/epy"
EGIT_REPO_URI="https://github.com/wustho/epy.git"

LICENSE="GPL-3"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( README.md LICENSE )
