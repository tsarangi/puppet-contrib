class condor::no_condor inherits condor::common {

  $_condor_etc = "/afs/hep.wisc.edu/condor/etc"

  if( $::domain == "physics.wisc.edu" ) {
    $_condor_etc_hosts = "${_condor_etc}/pwe"
  }
  else {
    $_condor_etc_hosts = "${_condor_etc}"
  }
  
  if ($::has_var_condor == 'false') {
    file {
      "/scratch/condor" :
        ensure => directory,
        owner => 'condor',
        group => 'root',
        mode => '755';

      "/var/condor" :
        ensure => link,
        target => "/scratch/condor";
    }
  }
  else {
    file {
      "/var/condor/spool" :
        ensure => directory,
        owner => 'condor',
        group => 'root',
        mode => '755';

      "/var/condor/execute" :
        ensure => directory,
        owner => 'condor',
        group => 'root',
        mode => '755';

      "/var/condor/.execute-links" :
        ensure => directory,
        owner => 'condor',
        group => 'root',
        mode => '755';
    }

    if ($::has_var_log_condor == 'true') {
      file {"var_condor_log" :
        path => "/var/condor/log",
        ensure => link,
        target => "/var/log/condor",
        force => true,
      }
    }
  }

  if($hostname in $cfeng::aaa_condor_nodes) {
    file {
      "/var/log/condor/aaa":
        ensure => directory,
        owner => 'condor',
        group => 'condor',
        mode => '0755';

      "/var/condor/execute-aaa":
        ensure => directory,
        owner => 'condor',
        group => 'root',
        mode => '0755';

      "/etc/condor/config.d/80aaa.config" :
        source => "${_condor_etc}/config.d/80aaa.config",
        owner => '0',
        group => '0',
        checksum => 'md5',
        backup => false,
        notify => Exec["kill_hup_condor"];
    }
  }
  
  file {
    # Condor 8.0.5 fails to create this directory automatically and then
    # falls back to /tmp/condorLocks, but preen ignores /tmp/condorLocks,
    # so eventually submit nodes run out of file descriptors.
    "/var/log/condor/local" :
      ensure => directory,
      owner => 'root',
      group => 'root',
      mode => '1777';

    "/etc/condor" :
      ensure => directory,
      owner => 'root',
      group => 'root',
      mode => '0755';

    "/usr/sbin/hddtemp" :
      ensure => present,
      owner => 'root',
      group => 'root',
      mode => '6755';

    "/etc/condor/condor_config.local" :
      source => "${_condor_etc}/condor_config.local",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];

    # override personal condor config from the OSG condor rpm
    "/etc/condor/config.d/00personal_condor.config" :
      source => "puppet:///modules/condor/00personal_condor.config",
      owner => '0',
      group => '0',
      checksum => 'md5',
      mode => '644',
      backup => false,
      notify => Exec["kill_hup_condor"];

    "/etc/condor/config.d/00hep_wisc.config" :
      source => "${_condor_etc}/config.d/00hep_wisc.config",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];

     #    "${_condor_etc}/${hostname}.local" :
    #      ensure => present,
    #      content => template("condor/hostname.local");
    
    "/etc/condor/${hostname}.local" :
      source => "${_condor_etc_hosts}/${hostname}.local",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];

    "/etc/condor/glow_config" :
      source => "${_condor_etc}/glow_config",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];

    "/etc/condor/config.d/70pilotcron.config" :
      source => "${_condor_etc}/config.d/70pilotcron.config",
      owner => '0',
      group => '0',
      checksum => 'md5',
      backup => false,
      notify => Exec["kill_hup_condor"];
    
    "/etc/condor/config.d/pilotcron.config" :
      ensure => absent;
    
   "/etc/condor/pool_password" :
      source => "puppet:///modules/condor/pool_password",
      owner => '0',
      group => '0',
      checksum => 'md5',
      mode => '400',
      backup => false;
    
    "/opt/hawkeye" :
      ensure => directory,
      source => "/afs/hep.wisc.edu/cms/sw/hawkeye",
      owner => '0',
      group => '0',
      recurse => inf,
      checksum => 'md5',
      ignore => [".hg*","*~",],
      backup => false;

    "/etc/condor/cpu_config" :
      ensure => directory,
      source => "${_condor_etc}/cpu_config",
      recurse => inf,
      owner => '0',
      group => '0',
      checksum => 'md5',
      ignore => ".hg*",
      backup => false;

  }

  if ($::osfamily == "Redhat") {
    if($::lsbmajdistrelease == 6) {
      cfeng::replace_all { 'condor_78811' :
        file => "/etc/yum/pluginconf.d/versionlock.list",
        pattern => "0:condor-7.8.8-110288.x86_64",
        replacement => "",
      }
      cfeng::replace_all { 'condor_7884' :
        file => "/etc/yum/pluginconf.d/versionlock.list",
        pattern => "0:condor-7.8.8-4.osg.el6.x86_64",
        replacement => "0:condor-8.0.5-2.osg32.el6.x86_64",
      }
      cfeng::replace_all { 'condor_procd_7884' :
        file => "/etc/yum/pluginconf.d/versionlock.list",
        pattern => "0:condor-procd-7.8.8-4.osg.el6.x86_64",
        replacement => "0:condor-procd-8.0.5-2.osg32.el6.x86_64",
      }
      cfeng::replace_all { 'condor_classads_7884' :
        file => "/etc/yum/pluginconf.d/versionlock.list",
        pattern => "0:condor-classads-7.8.8-4.osg.el6.x86_64",
        replacement => "0:condor-classads-8.0.5-2.osg32.el6.x86_64",
      }
  
      exec { "check_condor_in_version_lock" :
        command => 'echo "0:condor-8.0.5-2.osg32.el6.x86_64" >> /etc/yum/pluginconf.d/versionlock.list',
        path => "/bin:/usr/bin",
        unless => 'grep -q "0:condor-8.*" /etc/yum/pluginconf.d/versionlock.list',
        require => Cfeng::Replace_all["condor_7884"],
      }
      exec { "check_condor_procd_in_version_lock" :
        command => 'echo "0:condor-procd-8.0.5-2.osg32.el6.x86_64" >> /etc/yum/pluginconf.d/versionlock.list',
        path => "/bin:/usr/bin",
        unless => 'grep -q "0:condor-procd.*" /etc/yum/pluginconf.d/versionlock.list',
        require => Cfeng::Replace_all["condor_procd_7884"],
      }
      exec { "check_condor_classads_in_version_lock" :
        command => 'echo "0:condor-classads-8.0.5-2.osg32.el6.x86_64" >> /etc/yum/pluginconf.d/versionlock.list',
        path => "/bin:/usr/bin",
        unless => 'grep -q "0:condor-classads.*" /etc/yum/pluginconf.d/versionlock.list',
        require => Cfeng::Replace_all["condor_classads_7884"],
      }
    }
    else{
      yum::yumvlock {'condor' :
        mline => "0:condor-.*",
        pkgline => "0:condor-${condor_version}",
      }
    }
  }
  
  ### Be careful not to use range function arguments with different lengths
  ### e.g. slot01-slot128 will cause memory to blow out
  
  $links_all_slots_1 = range("slot01","slot99")
  condor::execute_links{$links_all_slots_1 :
    linkcase => 'var',
  }
  $links_all_slots_2 = range("slot100","slot128")
  condor::execute_links{$links_all_slots_2 :
    linkcase => 'var',
  }
}
