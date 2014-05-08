class condor inherits cfeng::groups {
  
  file {
    "/usr/local/bin/should_shutdown_condorQ.sh" :
      source => "puppet:///modules/condor/should_shutdown_condorQ.sh",
      owner => '0',
      group => '0',
      mode => "0544",
      checksum => 'md5',
      backup => false;
    
    "/etc/cron.d/should_shutdown_condorQ.cron" :
      source => "puppet:///modules/condor/should_shutdown_condorQ.cron",
      owner => '0',
      group => '0',
      mode => "0644",
      checksum => 'md5',
      backup => false;
    
  }
  if !($hostname in $no_condor) {
    include condor::common
    include condor::no_condor
    service { "condor" :
      ensure => running,
      enable => true,
      require => File["/etc/condor/config.d/00hep_wisc.config"],
    }
  } else {
    service { "condor" :
      ensure => stopped,
      enable => false,
    }
  }
  
  if ($hostname in $condor_primary_server) {
    include condor::server
  }
  
}
