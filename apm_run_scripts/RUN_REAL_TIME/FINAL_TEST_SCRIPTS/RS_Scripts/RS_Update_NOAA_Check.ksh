#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that wrfbdy files exist

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/update_bc" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/update_bc directory."

# Checking that wrfbdy files exist
if ! find . -type f -name "wrfbdy*" | grep -q .; then
    abort "ERROR: No wrfbdy* files found in dart_filter, exiting."
fi

# Checking if d02 exists and if so, the wrfinput_d02 file
#if [[ "${MAX_DOMAINS}" -eq 2 ]]; then
#    if ! ls wrfinput_d02* >/dev/null 2>&1; then
#        abort "ERROR: wrfinput_d02* file not found, exiting."
#    fi
#fi
