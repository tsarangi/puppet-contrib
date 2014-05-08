class condor::gangliad inherits condor::common {

  $_condor_etc = "/afs/hep.wisc.edu/condor/etc"

  file {
    "/etc/condor/ganglia.d" :
      source => "${_condor_etc}/ganglia.d",
      recurse => true,
      purge => false,
      ignore => "*~",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];
  }
}
