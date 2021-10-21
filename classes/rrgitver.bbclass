SRCREV = "${AUTOREV}"
# rebuild package when git is updated
PV = "gitr${SRCPV}"

# if we use rrgitver we also want to set the SRC_URI. This here basically is SRC_URI = "${SRC_URI_O}"
SRC_URI = "${@d.getVar('SRC_URI_O',1) if isinstance(d.getVar('SRC_URI_O'), str) else ''}"

inherit gitpkgv

# Default: Prefer Versioned over latest git
DEFAULT_PREFERENCE = "-1"
# Use git if rrusegit is in OVERRIDES
DEFAULT_PREFERENCE_rrusegit = ""

PKGV = "1.0+gitr${GITPKGV}"
