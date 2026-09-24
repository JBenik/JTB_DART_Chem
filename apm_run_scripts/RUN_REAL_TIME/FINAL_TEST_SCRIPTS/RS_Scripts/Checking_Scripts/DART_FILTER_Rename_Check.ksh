#!/bin/ksh -aux

let MEM=1
RETRY_COUNT=${1:-0}
MAX_RETRIES=1

let x=0 
while [[ ${MEM} -le ${NUM_MEMBERS} ]]; do
   export CMEM=e${MEM}
   export KMEM=${MEM}
   if [[ ${MEM} -lt 1000 ]]; then export KMEM=0${MEM}; fi
   if [[ ${MEM} -lt 100 ]]; then export KMEM=00${MEM}; export CMEM=e0${MEM}; fi
   if [[ ${MEM} -lt 10 ]]; then export KMEM=000${MEM}; export CMEM=e00${MEM}; fi

   # Check wrfchemi
   if ! ncdump -h wrfchemi_d${CR_DOMAIN}_${LL_FILE_DATE}_filt.${CMEM} | grep -q chemi_zdim_stag; then
        echo "JTB: ERROR: Missing chemi_zdim_stag in wrfchemi file ${CMEM}"
        let x=1 
   fi  

   # Check wrffirechemi
   if ! ncdump -h wrffirechemi_d${CR_DOMAIN}_${LL_FILE_DATE}_filt.${CMEM} | grep -q fire_zdim_stag; then
        echo "JTB: ERROR: Missing fire_zdim_stag in wrffirechemi file ${CMEM}"
        let x=1 
   fi  

   # Check WRFCHEMI DARTVARS
   CHEMI_DARTVARS_SearchString="${WRFCHEMI_DARTVARS//,/|}"
   if ! ncdump -h wrfchemi_d${CR_DOMAIN}_${LL_FILE_DATE}_filt.${CMEM} | grep -qE "${CHEMI_DARTVARS_SearchString}"; then
        echo "JTB: ERROR: Missing one or more DARTVARS in wrfchemi file ${CMEM}"
        let x=1 
   fi  

   # Check WRFFIRECHEMI DARTVARS
   FIRECHEMI_DARTVARS_SearchString="${WRFFIRECHEMI_DARTVARS//,/|}"
   if ! ncdump -h wrffirechemi_d${CR_DOMAIN}_${LL_FILE_DATE}_filt.${CMEM} | grep -qE "${FIRECHEMI_DARTVARS_SearchString}"; then
        echo "JTB: ERROR: Missing one or more DARTVARS in wrffirechemi file ${CMEM}"
        let x=1 
   fi  
   
   # CRITICAL: Increment MEM so the loop eventually ends!
   let MEM=MEM+1
done

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
