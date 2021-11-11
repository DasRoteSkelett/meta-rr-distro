# This should be overwritten by bsp layer
PREFERRED_VERSION_linux-yocto ?= "5.10%"
PREFERRED_VERSION_linux-yocto-rt ?= "5.10%"

SDK_NAME = "${DISTRO}-${TCLIBC}-${SDKMACHINE}-${IMAGE_BASENAME}-${TUNE_PKGARCH}-${MACHINE}"
SDKPATH = "/opt/${DISTRO}/${SDK_VERSION}"

DISTRO_EXTRA_RDEPENDS += "${POKY_DEFAULT_EXTRA_RDEPENDS}"
DISTRO_EXTRA_RRECOMMENDS += "${POKY_DEFAULT_EXTRA_RRECOMMENDS}"

TCLIBCAPPEND = ""

PREMIRRORS ??= "\
bzr://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
cvs://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
git://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
gitsm://.*/.* http://downloads.yoctoproject.org/mirror/sources/ \n \
hg://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
osc://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n \
p4://.*/.*    http://downloads.yoctoproject.org/mirror/sources/ \n \
svn://.*/.*   http://downloads.yoctoproject.org/mirror/sources/ \n"

SANITY_TESTED_DISTROS ?= " \
            poky-3.2 \n \
            poky-3.3 \n \
            ubuntu-16.04 \n \
            ubuntu-18.04 \n \
            ubuntu-20.04 \n \
            fedora-31 \n \
            fedora-32 \n \
            fedora-33 \n \
            centos-7 \n \
            centos-8 \n \
            debian-8 \n \
            debian-9 \n \
            debian-10 \n \
            opensuseleap-15.1 \n \
            opensuseleap-15.2 \n \
	    gentoo \n \
            "
# add poky sanity bbclass
INHERIT += "poky-sanity"

INIT_MANAGER = "systemd"
VIRTUAL-RUNTIME_init_manager = "systemd"
DISTRO_FEATURES_BACKFILL_CONSIDERED = "sysvinit"

PREFERRED_PROVIDER_virtual/base-utils = "coreutils"
VIRTUAL-RUNTIME_base-utils = "coreutils"
VIRTUAL-RUNTIME_base-utils-hwclock = "util-linux-hwclock"
VIRTUAL-RUNTIME_base-utils-syslog = ""
VIRTUAL-RUNTIME_initscripts = ""
VIRTUAL-RUNTIME_syslog = ""

require conf/distro/include/poky-world-exclude.inc
require conf/distro/include/no-static-libs.inc
require conf/distro/include/yocto-uninative.inc
require conf/distro/include/security_flags.inc
INHERIT += "uninative"

INHERIT += "reproducible_build"

# remove unused distro features from poky
DISTRO_FEATURES:remove = "bluetooth pcmcia usbgadget wifi nfs 3g nfc pulseaudio"

BB_SIGNATURE_HANDLER ?= "OEEquivHash"
BB_HASHSERVE ??= "auto"
