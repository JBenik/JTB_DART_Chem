#!/bin/ksh -aux

# This script was developed by Jeremy T. Benik
# Jeremy.T.Benik@NASA.gov

# Defining a re-usable error function
abort() {
    echo "$1" | tee ERROR.html >&2
    exit 1
}

# Checking if the directory exists, if not, exit
cd "${RUN_DIR}/${DATE}/metgrid" || abort "ERROR: Could not find or access ${RUN_DIR}/${DATE}/metgrid directory."

# Checking for index files in metgrid
if [[ ! -e index.html || ! -e index_rs.html ]]; then
    abort "ERROR: One or more index files not found, exiting."
fi

# Checking that metgrid finished successfully
if ! grep -qF "Successful completion of metgrid." index.html; then
    abort "ERROR: Metgrid did not complete successfully, exiting."
fi

# Checking for keywords for errors, but omitting removing jobx.ksh since it pops up a lot
if grep -E "ERROR|cannot|MPT|SIG|not|foo|FATAL|segmentation fault|file not found|err|fatal" index* | grep -qv "rm: cannot remove 'jobx.ksh'"; then
    abort "ERROR: Error keyword present in index file, exiting."
fi

# Checking if FILE* exists. 
if ! ls met_em.d01* >/dev/null 2>&1; then
    abort "ERROR: No met_em.d01* files found, exiting."
fi

# Checking if d02 exists and if so, the met_em.d02 file
if [[ "${MAX_DOMAINS}" -eq 2 ]]; then
    if ! ls met_em.d02* >/dev/null 2>&1; then
        abort "ERROR: met_em.d02.nc file not found, exiting."
    fi
fi
