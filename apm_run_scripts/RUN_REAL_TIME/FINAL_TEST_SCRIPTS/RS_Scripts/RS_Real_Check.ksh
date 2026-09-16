#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that the index_rs.html file exists
#	3. Check that real ran sucessfully in rsl.out.0000
#	4. Check that real ran sucessfully in rsl.error.0000
#	5. Check that no keywords present in an index file
#	6. Check that wrfinput_d01 file exists


# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/real" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/real directory."

# Checking for index files in real
if [[ ! -e index_rs.html ]]; then
    abort "ERROR: index_rs.html file not found, exiting."
fi

# Checking that real finished successfully
if ! grep -qF "SUCCESS COMPLETE REAL_EM INIT" rsl.out.0000; then
    abort "ERROR: Real did not complete successfully, exiting."
fi

# Checking that real finished successfully
if ! grep -qF "SUCCESS COMPLETE REAL_EM INIT" rsl.error.0000; then
    abort "ERROR: Real did not complete successfully, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|not|foo|FATAL|segmentation fault|file not found|error|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if wrfinput_d01* exists. 
if ! ls wrfinput_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfinput_d01* files found, exiting."
fi

# Checking if d02 exists and if so, the wrfinput_d02 file
#if [[ "${MAX_DOMAINS}" -eq 2 ]]; then
#    if ! ls wrfinput_d02* >/dev/null 2>&1; then
#        abort "ERROR: wrfinput_d02* file not found, exiting."
#    fi
#fi
