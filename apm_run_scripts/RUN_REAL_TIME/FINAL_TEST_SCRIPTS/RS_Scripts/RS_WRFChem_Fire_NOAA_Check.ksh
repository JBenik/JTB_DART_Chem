#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index_rs exists
#	3. Check that no keywords present in an index file
#	4. Check that the wrffirechemi files are present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/wrfchem_fire" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/fire directory."

# Checking for index files in fire
if [[ ! -e index_rs.html ]]; then
    abort "ERROR: index_rs.html file not found, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if wrfbdy_d01* exists. 
if ! ls wrffirechemi_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrffirechemi* files found, exiting."
fi
