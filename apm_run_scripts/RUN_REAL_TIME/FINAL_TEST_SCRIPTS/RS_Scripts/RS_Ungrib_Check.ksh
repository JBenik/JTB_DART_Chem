#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/ungrib" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/ungrib directory."

# Checking for index files in ungrib
if [[ ! -e index.html || ! -e index_rs.html ]]; then
    abort "ERROR: One or more index files not found, exiting."
fi

if ! grep -qF "Successful completion of program ungrib.exe" ungrib.log; then
    abort "ERROR: Ungrib did not complete successfully, exiting."
fi

# Checking that ungrib finished successfully
if ! grep -qF "Successful completion of ungrib." index.html; then
    abort "ERROR: Ungrib did not complete successfully, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|not|foo|FATAL|segmentation fault|file not found|err|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if FILE* exists. 
if ! ls FILE* >/dev/null 2>&1; then
    abort "ERROR: No FILE* files found, exiting."
fi

# Checking if GRIBFILEFILE* exists. 
if ! ls GRIBFILE* >/dev/null 2>&1; then
    abort "ERROR: No GRIBFILE* files found, exiting."
fi
