FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://locale.conf \
	    file://vconsole.conf \
	   "

PACKAGECONFIG:append = " coredump "

do_install:append() {
   install -m 0644 ${WORKDIR}/locale.conf ${D}${sysconfdir}/locale.conf
   install -m 0644 ${WORKDIR}/vconsole.conf ${D}${sysconfdir}/vconsole.conf  
}

FILES:${PN} += " \
	        ${sysconfdir}/locale.conf \
		${sysconfdir}/vconsole.conf \
 	       "