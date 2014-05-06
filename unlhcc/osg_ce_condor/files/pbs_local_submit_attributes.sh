#!/bin/sh

# Set walltime according to request; the batch system
# may reject this, of course!
if [ -n "$Walltime" ]; then
  echo "#PBS -l walltime=$Walltime"
else
  echo "#PBS -l walltime=24:00:00"
fi

