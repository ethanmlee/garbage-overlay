EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit cmake python-single-r1

DESCRIPTION="This is a fork of polybar-dwm-module which upgrades the package to 3.6.3"
HOMEPAGE="https://github.com/pgrondek/polybar-dwm/tree/master"

EGIT_COMMIT="a325d7e0656c7de1d2af0437785e8d433b23d3fc"
XPP_COMMIT="044e69d05db7f89339bda1ccd1efe0263b01c8f6"
DWMIPCPP_COMMIT="6b6947fd63845c8239f0a895be695bf206eaae6d"
I3IPCPP_COMMIT="cb008b30fc5f3febfe467884cb0211ee3c16386b"
SRC_URI="
	https://github.com/pgrondek/polybar-dwm/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz
	https://github.com/polybar/xpp/archive/${XPP_COMMIT}.tar.gz
		-> xpp-${XPP_COMMIT}.tar.gz
	https://github.com/mihirlad55/dwmipcpp/archive/${DWMIPCPP_COMMIT}.tar.gz
		-> dwmipcpp-${DWMIPCPP_COMMIT}.tar.gz
	i3wm? (
		https://github.com/polybar/i3ipcpp/archive/${I3IPCPP_COMMIT}.tar.gz
			-> i3ipcpp-${I3IPCPP_COMMIT}.tar.gz )
"
S=${WORKDIR}/polybar-dwm-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
IUSE="i3wm alsa curl doc ipc mpd network pulseaudio"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="amd64"

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
	i3wm? (
		dev-libs/jsoncpp:=
		x11-wm/i3
	)
	network? ( dev-libs/libnl:3 )
	dev-libs/jsoncpp
	media-libs/fontconfig
	media-libs/freetype
	curl? ( net-misc/curl )
	dev-libs/libuv:=
	x11-libs/libxcb:=
	x11-libs/xcb-util
"
RDEPEND="${DEPEND}"

src_prepare() {
	rmdir lib/xpp || die
	mv "${WORKDIR}/xpp-${XPP_COMMIT}" lib/xpp || die
	rmdir lib/dwmipcpp || die
	mv "${WORKDIR}/dwmipcpp-${DWMIPCPP_COMMIT}" lib/dwmipcpp || die
	if use i3wm; then
		rmdir lib/i3ipcpp || die
		mv "${WORKDIR}/i3ipcpp-${I3IPCPP_COMMIT}" lib/i3ipcpp || die
	fi

	cmake_src_prepare

	default
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ALSA="$(usex alsa)"
		-DENABLE_CURL="$(usex curl)"
		-DBUILD_DOC="$(usex doc)"
		-DENABLE_I3="$(usex i3wm)"
		-DBUILD_IPC_MSG="$(usex ipc)"
		-DENABLE_MPD="$(usex mpd)"
		-DENABLE_NETWORK="$(usex network)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		-DENABLE_DWM="ON"
		# Bug 767949
		-DENABLE_CCACHE="OFF"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc/"
		# force-link freetype
        -DCMAKE_EXE_LINKER_FLAGS="-lfreetype"
	)

	cmake_src_configure "${mycmakeargs[@]}"
}
