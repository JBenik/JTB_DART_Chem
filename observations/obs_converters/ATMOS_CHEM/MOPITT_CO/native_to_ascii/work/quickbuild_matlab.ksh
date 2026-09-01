#!/bin/ksh -aux
#
# COPY EXECUTABLE
   export RUN_DIR=./
   export CODE_DIR=../
   export MFILE=mopitt_v8_co_profile_extract.m
   export OFILE=mopitt_v8_co_profile_extract
   export MFILE=mopitt_v9_co_profile_extract.m
   export OFILE=mopitt_v9_co_profile_extract
   rm ${MFILE}
   rm ${OFILE}
   cp ${CODE_DIR}${MFILE} ${RUN_DIR}.
   mcc -m ${MFILE} -o ${OFILE}
   rm ${MFILE}
   rm include*
   rm mccExclude*
   rm readme*
   rm required*
   rm unresolved*
#
