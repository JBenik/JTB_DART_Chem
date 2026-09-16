#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# This program checks for:
#	1. Check if the directory exists
#	2. Check that index files exist
#	3. Check that the wrfout files are present
#	4. Check that the wrfchemi files are present
#	5. Check that the wrffirechemi files are present
#	6. Check that the obs_seq.final file is present
#	7. Check that the wrfinput file is present

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/dart_filter" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/dart_filter directory."

# Checking for index files in dart_filter
if [ ! -e index_rs.html ] || [ ! -e index_dart.html ] || [ ! -e index_nco1.html ] || [ ! -e index_nco2 ]; then
    abort "ERROR: one or more index files not found, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -rE "ERROR|cannot|MPT|SIG|foo|FATAL|segmentation fault|file not found|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking that wrfout files exist
if ! find . -type f -name "wrfout*" | grep -q .; then
    abort "ERROR: No wrfout* files found in dart_filter, exiting."
fi

# Checking that wrfchemi files exist
if ! find . -type f -name "wrfchemi*" | grep -q .; then
    abort "ERROR: No wrfchemi* files found in dart_filter, exiting."
fi

# Checking that wrffirechemi files exist
if ! find . -type f -name "wrffirechemi*" | grep -q .; then
    abort "ERROR: No wrffirechemi* files found in dart_filter, exiting."
fi

# Checking that obs_seq.final exist
if [[ ! -e obs_seq.final ]]; then
    abort "ERROR: No obs_seq.final found in dart_filter, exiting."

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
