#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index_rs exists
#	3. Check that there are 5 index files
#	4. Check that no keywords present in an index file
#	5. Check that the wrfbiochemi files are present
#	6. Check that the wrfchemi files are present
#	7. Check that the wrffirechemi files are present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/wrfchem_chem_emiss" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/wrfchem_chem_emiss directory."

# Checking for index files in chem_emiss
if [[ ! -e index_rs.html ]]; then
    abort "ERROR: index_rs not found, exiting."
fi

# Checking that the other index files were created
index_count=$(ls -1d index* 2>/dev/null | wc -l)
if [[ "$index_count" -ne 5 ]]; then
    abort "Missing an index file, please check wrfchem_chem_emiss"
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if wrfbiochemi_d01* exists. 
if ! ls wrfbiochemi_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfbiochemi_d01* files found, exiting."
fi

# Checking if wrfchemi_d01* exists. 
if ! ls wrfchemi_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfchemi_d01* files found, exiting."
fi

# Checking if wrffirechemi_d01* exists. 
if ! ls wrffirechemi_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrffirechemi_d01* files found, exiting."
fi
