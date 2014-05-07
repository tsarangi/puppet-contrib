#!/bin/sh
# script to shutdown condor under emergency circumstances,
# such as when /var/condor is Read-Only

SHUTDOWN=0
MAILLIST="cmsops@hep.wisc.edu,cwseys@physics.wisc.edu"
OUTPUT=`mktemp -p /dev/shm`


CONDORRO="`cat /proc/mounts | grep condor | grep 'ro,'`"
SCRATCHRO="`cat /proc/mounts | grep scratch | grep 'ro,'`"

if [ "${CONDORRO}" != "" -o "${SCRATCHRO}" != "" ]; then
	echo "${CONDORRO}" >> "${OUTPUT}"
	echo "${SCRATCHRO}" >> "${OUTPUT}"
	SHUTDOWN=1
fi

# here add check for full partition /scratch and /var/condor

if [ $SHUTDOWN -eq 1 ]; then
	SU="Would shut down condor on $(hostname)"
	mail -s "${SU}" "${MAILLIST}" < "${OUTPUT}"
#	/etc/init.d/condor stop

	rm "${OUTPUT}"
	true
else
	rm "${OUTPUT}"
	false
fi

