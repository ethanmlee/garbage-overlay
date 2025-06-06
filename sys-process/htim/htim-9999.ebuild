EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

# We avoid xdg.eclass here because it'll pull in glib, desktop utils on
# htop which is often used on headless machines. bug #787470
inherit linux-info optfeature python-any-r1 xdg-utils

DESCRIPTION="This is htop with vim key bindings and visual mode"
HOMEPAGE="https://gitlab.com/thelinuxguy9/htim"
EGIT_REPO_URI="https://gitlab.com/thelinuxguy9/htim.git"
inherit autotools git-r3

S="${WORKDIR}/${P/_}"

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="caps debug delayacct hwloc lm-sensors llvm-libunwind openvz unicode unwind vserver"

RDEPEND="
	!sys-process/htop
	sys-libs/ncurses:=[unicode(+)?]
	hwloc? ( sys-apps/hwloc:= )
	unwind? (
		!llvm-libunwind? ( sys-libs/libunwind:= )
		llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	)
	kernel_linux? (
		caps? ( sys-libs/libcap )
		delayacct? ( dev-libs/libnl:3 )
		lm-sensors? ( sys-apps/lm-sensors )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( ChangeLog README )

CONFIG_CHECK="~TASKSTATS ~TASK_XACCT ~TASK_IO_ACCOUNTING ~CGROUPS"

pkg_setup() {
	python-any-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	if [[ ${CBUILD} != ${CHOST} ]] ; then
		# bug #328971
		export ac_cv_file__proc_{meminfo,stat}=yes
	fi

	local myeconfargs=(
		--enable-unicode
		$(use_enable debug)
		$(use_enable hwloc)
		$(use_enable !hwloc affinity)
		$(use_enable openvz)
		$(use_enable unicode)
		$(use_enable unwind)
		$(use_enable vserver)
	)

	if use kernel_linux ; then
		myeconfargs+=(
			$(use_enable caps capabilities)
			$(use_enable delayacct)
			$(use_enable lm-sensors sensors)
		)
	else
		if use kernel_Darwin ; then
			# Upstream default to checking but --enable-affinity
			# overrides this. Simplest to just disable on Darwin
			# given it works on BSD anyway.
			myeconfargs+=( --disable-affinity )
		fi

		myeconfargs+=(
			--disable-capabilities
			--disable-delayacct
			--disable-sensors
		)
	fi

	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	optfeature "Viewing processes accessing certain files" sys-process/lsof
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
