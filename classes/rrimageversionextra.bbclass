# code style checked using flake8:
# flake8 --statistics --ignore=E999 <this-file>


def do_revision(d):
    import subprocess
    import re
    mydir = (d.getVar("COREBASE")) + "/.."
    revision = ""
    try:
        revision = subprocess.check_output(
            """ cd %s
                PSEUDO_UNLOAD=1
                set -e
                git describe --tags --dirty
            """ % mydir,
            shell=True,
            stderr=subprocess.STDOUT).decode('utf-8')
    except subprocess.CalledProcessError:
        return ""
    if revision:
        regex_base = "v?([0-9]+).([0-9]+).([0-9]+)"
        regex_opt = "(-([0-9]+)-g([0-9a-f]){7})?(-dirty)?"
        match = re.match(regex_base + regex_opt, revision.rstrip())
        if match and match.group(0):
            return match.group(0)
    return ""


def do_normalized_version(version):
    import re
    version_split = re.sub("[^0-9.]", "", version.split("-", 1)[0])
    # 1st length check for <16bit>.<8bit>.<8bit> (DCe limits)
    # leading zeros not allowed
    regex = "^(0|[1-9][0-9]{0,4}).(0|[1-9][0-9]{0,2}).(0|[1-9][0-9]{0,2})$"
    match = re.match(regex, version_split)
    if match:
        normalized_version = match.group(0)
        try:
            tup = normalized_version.split('.', 3)
            major, minor, patch = int(tup[0]), int(tup[1]), int(tup[2])
        except Exception:
            return ""
        # 2nd range check for known limits
        if 0 <= major <= 65535 and 0 <= minor <= 255 and 0 <= patch <= 255:
            return normalized_version
    return ""


def do_build_type(d):
    debug_build = d.getVar('DEBUG_BUILD')
    if debug_build and debug_build == "1":
        return "debug"
    return "release"


python add_itximageversionextra() {
    IIVE_PREFIX = "[itximageversionextra]"
    VERSION_FILE = '${IMAGE_ROOTFS}${sysconfdir}/version.conf'

    # retrieve vcs revision info (detailed version)
    revision = do_revision(d)
    if not revision:
        print("%s ERROR: Unable to retrieve revision!" % IIVE_PREFIX)
        exit(1)

    # retrieve normalized version (major.minor.patch)
    normalized_version = do_normalized_version(revision)
    if not normalized_version:
        print("%s ERROR: Unable to retrieve normalized version!"
              % IIVE_PREFIX)
        exit(1)
    print("%s normalized version: %s"
          % (IIVE_PREFIX, normalized_version))

    # retrieve build type
    build_type = do_build_type(d)
    if not build_type:
        print("%s ERROR: Unable to retrieve build type!"
              % IIVE_PREFIX)
        exit(1)
    print("%s build type: %s" % (IIVE_PREFIX, build_type))

    # create versioning sequence to write
    version_data = ["version.info=" + build_type + "\n",
                    "version.long_str=" + revision + "\n",
                    "version.str=" + normalized_version + "\n"]

    # write sequence to version file in image rootfs
    with open(d.expand(VERSION_FILE), 'w') as version_file:
        version_file.writelines(version_data)
        version_file.close()
}

IMAGE_PREPROCESS_COMMAND += "add_itximageversionextra;"
