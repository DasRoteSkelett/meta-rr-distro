# returns sca, if SCA_ENABLE is set in local.conf
def get_sca_enabled(bb, d):
    if d.getVar('SCA_ENABLE', '0') == '1':
        return " sca "
    else:
        return " "

inherit cmake ${@get_sca_enabled(bb, d)}

# Add python3 native for correct gitversion in cmake template
DEPENDS_prepend = "python3-native "

# Disable mirrors here to prevent that the build process
# tries to download internal code from the public yocto repositories
PREMIRRORS = ""
MIRRORS = ""

EXTRA_OECMAKE += " -DBUILD_TESTING=OFF "

# Fetch recent tags actively to ensure correct referencing for the
# version detection. This should fix a known issue with the caching
# of the gitlab sources and the availability of recent tags.
python do_unpack_append() {
    bb.debug(1, 'do_unpack_append: fetching possibly missing git tags...')
    import os
    srcdir = d.getVar('S', True)
    os.chdir(srcdir)
    stream = os.popen('git fetch --tags --verbose 2>&1')
    output = stream.read()
    bb.debug(1, 'do_unpack_append: tag fetching output:\n' + output)
}
