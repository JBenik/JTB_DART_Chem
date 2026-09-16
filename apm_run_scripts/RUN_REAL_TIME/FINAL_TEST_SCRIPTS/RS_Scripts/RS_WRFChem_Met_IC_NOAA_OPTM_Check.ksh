#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index_rs exists
#	3. Check that WRF-Var completed successfully in rsl.out.0000
#	4. Check that WRF-Var completed successfully in rsl.error.0000
#	5. Check that no keywords present in an index file
#	6. Check that the wrfinput files are present
#	7. Check that the new_mean files are present
#	8. Check that the parent files are present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/wrfchem_met_ic" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/wrfchem_met_ic directory."

# Checking for index files in wrfchem_met_ic
if [[ ! -e index_rs.html ]]; then
    abort "ERROR: index_rs.html file not found, exiting."
fi

# Checking that wrfvar finished successfully
if ! grep -rqF --include="rsl.out.0000" "WRF-Var completed successfully" .; then
    abort "ERROR: WRF-Var completion message not found in rsl.out.0000, exiting."
fi

# Checking that wrfvar finished successfully
if ! grep -rqF --include="rsl.error.0000" "WRF-Var completed successfully" .; then
    abort "ERROR: WRF-Var completion message not found in rsl.error.0000, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if wrfinput_d01* exists. 
if ! ls wrfinput_d01* >/dev/null 2>&1; then
    abort "ERROR: No wrfinput_d01* files found, exiting."
fi

# Checking if wrfinput_d01* exists. 
if ! ls wrfinput_d01*new_mean >/dev/null 2>&1; then
    abort "ERROR: No wrfinput_d01*new_mean files found, exiting."
fi

# Checking if wrfinput_d01* exists. 
if ! ls wrfinput_d01*parent >/dev/null 2>&1; then
    abort "ERROR: No wrfinput_d01*parent files found, exiting."
fi

# Checking if d02 exists and if so, the wrfinput_d02 file
#if [[ "${MAX_DOMAINS}" -eq 2 ]]; then
#    if ! ls wrfinput_d02* >/dev/null 2>&1; then
#        abort "ERROR: wrfinput_d02* file not found, exiting."
#    fi
#fi
