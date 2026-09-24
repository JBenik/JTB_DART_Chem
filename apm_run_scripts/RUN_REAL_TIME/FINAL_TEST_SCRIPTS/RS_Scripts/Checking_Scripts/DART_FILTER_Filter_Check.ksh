#!/bin/ksh -aux

RETRY_COUNT=${1:-0}
MAX_RETRIES=1

# Check wrfchemi
if [ ! grep -q "Finished ... at YYYY MM DD HH MM SS =" index_dart.html ] || [ grep -q ERROR index_dart.html ]; then
	echo "JTB: ERROR when running filter, resubmiting it"
	let x=1 
fi  

if (( x == 1 )); then
    if (( RETRY_COUNT < MAX_RETRIES )); then
        echo "JTB: WARNING: Check failed! Resubmitting the job to the HPC queue"
    
        # Increment the counter
        let RETRY_COUNT=RETRY_COUNT+1
    
        # Removed -Wblock=true so this job can exit and free up nodes
        qsub -F "$RETRY_COUNT" job.ksh
    
        # Exit 0 cleanly so the scheduler frees up the current compute node(s)
        echo "Resubmission successful. Ending current job."
        exit 0
    else
        # We hit the max limit of retries
        echo "ERROR: Checks failed again after $MAX_RETRIES resubmission(s). Exiting permanently!"
        exit 1 # Exit with error code so the scheduler logs a failed job
    fi  
fi
