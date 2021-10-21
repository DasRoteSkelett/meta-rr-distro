
def do_revision(d):
    import bb
    import subprocess
    mydir = (d.getVar("COREBASE")) + "/.."
    revision = ""
    try:
        revision = subprocess.check_output("""cd %s; export PSEUDO_UNLOAD=1; set -e;                             git describe --tags --dirty""" % mydir,
                                shell=True,
                                stderr=subprocess.STDOUT).decode('utf-8')
    except subprocess.CalledProcessError as ex:
        # Silently treat errors as "modified", without checking for the
        # (expected) return code 1 in a modified git repo. For example, we get
        # output and a 129 return code when a layer isn't a git repo at all.
        revision = "INVALID-NORELEASE"
    finalrevision = revision.rstrip()
    return finalrevision
python add_itxversion_to_image() {
        with open(d.expand('${IMAGE_ROOTFS}${sysconfdir}/itxversion'), 'w') as build:
             build.writelines((do_revision(d)))
}
IMAGE_PREPROCESS_COMMAND += "add_itxversion_to_image;"
