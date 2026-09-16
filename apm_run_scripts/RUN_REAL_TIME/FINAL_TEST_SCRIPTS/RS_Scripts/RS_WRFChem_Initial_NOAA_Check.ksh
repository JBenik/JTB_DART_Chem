#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index_rs exists
#	3. Check that rsl.out.0000 completed
#	4. Check that rsl.error.0000 completed
#	5. Check that no keywords present in an index file
#	6. Check that the wrfout files are present
#	7. Check that the wrfbiochemi files are present
#	8. Check that the wrffirechemi files are present
#	9. Check that the wrfinput_d01 files are present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/wrfchem_cycle_cr" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/wrfchem_cycle_cr directory."

# Checking for index files in wrfchem_cycle_cr
if [[ ! -e index_rs.html ]]; then
    abort "ERROR: index_rs.html file not found, exiting."
fi

# Checking that wrfvar finished successfully
if ! grep -rqF --include="rsl.out.0000" "wrf: SUCCESS COMPLETE WRF" .; then
    abort "ERROR: wrf completion message not found in rsl.out.0000, exiting."
fi

# Checking that wrfvar finished successfully
if ! grep -rqF --include="rsl.error.0000" "wrf: SUCCESS COMPLETE WRF" .; then
    abort "ERROR: wrf completion message not found in rsl.error.0000, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -rE "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'" | grep -qv "MPTABLE.TBL"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking that wrfout files exist
if ! find . -type f -name "wrfout*" | grep -q .; then
    abort "ERROR: No wrfout* files found in any subdirectory, exiting."
fi

# Checking that wrfbiochemi files exist
if ! find . -type f -name "wrfbiochemi*" | grep -q .; then
    abort "ERROR: No wrfbiochemi* files found in any subdirectory, exiting."
fi

# Checking that wrfchemi files exist
if ! find . -type f -name "wrfchemi*" | grep -q .; then
    abort "ERROR: No wrfchemi* files found in any subdirectory, exiting."
fi

# Checking that wrffirechemi files exist
if ! find . -type f -name "wrffirechemi*" | grep -q .; then
    abort "ERROR: No wrffirechemi* files found in any subdirectory, exiting."
fi

# Checking that wrfinput_d01 files exist
if ! find . -type f -name "wrfinput_d01" | grep -q .; then
    abort "ERROR: No wrfinput_d01 files found in any subdirectory, exiting."
fi


# Checking if d02 exists and if so, the wrfinput_d02 file
#if [[ "${MAX_DOMAINS}" -eq 2 ]]; then
#    if ! ls wrfinput_d02* >/dev/null 2>&1; then
#        abort "ERROR: wrfinput_d02* file not found, exiting."
#    fi
#fi
