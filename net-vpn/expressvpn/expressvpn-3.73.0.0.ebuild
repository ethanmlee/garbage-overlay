# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ExpressVPN Client"
HOMEPAGE="https://www.expressvpn.com"
SRC_URI="https://www.expressvpn.works/clients/linux/expressvpn-3.73.0.0-1-x86_64.pkg.tar.xz"

LICENSE="custom"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-arch/xz-utils"
RDEPEND="net-misc/curl"

src_install() {
    cp -r "${WORKDIR}"/etc "${D}"/etc
    cp -r "${WORKDIR}"/usr "${D}"/usr
}

pkg_postinst() {
    elog "ExpressVPN has been installed. Please follow the instructions"
    elog "on the ExpressVPN website to configure and use the client."
}

