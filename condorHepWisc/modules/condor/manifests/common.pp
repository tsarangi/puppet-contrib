class condor::common {

  package { "condor" :
    ensure => installed,
  }
  
  exec { "kill_hup_condor" :
    command => "/usr/bin/condor_config_val MASTER > /dev/null && /usr/bin/pkill -HUP condor_master", 
    path => "/bin:/usr/bin:/usr/local/bin",
    refreshonly => true,
  }
  
}
  
