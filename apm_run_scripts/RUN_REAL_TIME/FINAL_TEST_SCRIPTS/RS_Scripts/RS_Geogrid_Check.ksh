#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/geogrid" || abort "ERROR: Could not find or access ${RUN_DIR}/geogrid directory."

# Checking for index files in geogrid
if [[ ! -e index.html || ! -e index_rs.html ]]; then
    abort "ERROR: One or more index files not found, exiting."
fi

# Checking that geogrid finished successfully
if ! grep -qF "Successful completion of geogrid." index.html; then
    abort "ERROR: Geogrid did not complete successfully, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|not|foo|FATAL|segmentation fault|file not found|err|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking that d01 geo_em file was generated
if [[ ! -e geo_em_d01.nc ]]; then
    abort "ERROR: geo_em_d01.nc file not found, exiting."
fi

# Checking if d02 exists and if so, the geo_em_d02 file
if [[ "${MAX_DOMAINS}" -eq 2 && ! -e geo_em_d02.nc ]]; then
    abort "ERROR: geo_em_d02.nc file not found, exiting."
fi
