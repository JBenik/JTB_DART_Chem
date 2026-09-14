#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index_rs exists
#	3. Check that no keywords present in an index file
#	4. Check that the wrfchemi files are present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/wrfchem_chem_icbc" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/wrfchem_chem_icbc directory."

# Checking for index files in chemi
if [ ! -e index_rs.html ] || [ ! -e index_nco.html ] || [ ! -e index_pert.html ]; then
    abort "ERROR: One or more index files not found, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if wrfbdy_d01* exists. 
if ! ls wrfbdy_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfbdy* files found, exiting."
fi

# Checking if wrfbdy_d01* exists. 
if ! ls wrfinput_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfinput_d01* files found, exiting."
fi
