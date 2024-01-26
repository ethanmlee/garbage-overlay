# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

inherit git-r3 cmake python-single-r1

DESCRIPTION="polybar-dwm-module is a fork of polybar which implements a dwm module."
HOMEPAGE="https://github.com/pgrondek/polybar-dwm-module"

EGIT_REPO_URI="https://github.com/pgrondek/polybar-dwm.git"
EGIT_SUBMODULES=(
	lib/dwmipcpp
	lib/i3ipcpp
	lib/xpp
)

LICENSE="MIT"
SLOT="0"
IUSE="alsa curl doc ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'x11-base/xcb-proto[${PYTHON_USEDEP}]')
	x11-libs/cairo[X,xcb(+)]
	x11-libs/xcb-util-image
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-xrm
	x11-libs/xcb-util-cursor
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )
	mpd? ( media-libs/libmpdclient )
	doc? ( dev-python/sphinx )
	network? ( dev-libs/libnl )
	dev-libs/jsoncpp
	media-libs/fontconfig
	media-libs/freetype
	curl? ( net-misc/curl )
	dev-libs/libuv:=
	x11-libs/libxcb:=
	x11-libs/xcb-util
"

RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DBUILD_DOC="$(usex doc)"
		-DBUILD_IPC_MSG="$(usex ipc)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		-DENABLE_DWM="ON"
	)

	cmake_src_configure
}
