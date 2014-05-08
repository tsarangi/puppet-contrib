class condor::server{
  
  file { "/etc/cron.d/condor-absent" :
    source => "/afs/hep.wisc.edu/admin/cron/condor-absent",
    owner => 'cmsprod',
    group => 'cmsprod',
    mode => '644',
    checksum => 'md5',
    backup => false;

  "/var/log/group_prio_adjust.log" :
    owner => 'cmsprod',
    group => 'cmsprod',
    mode => '644';

  "/etc/logrotate.d/group_prio_adjust" :
    source => "puppet:///modules/condor/rotate_group_prio_log",
    owner => '0',
    group => '0',
    mode => '444',
    checksum => 'md5',
    backup => false;

  "/etc/cron.d/condor-cm.cron" :
    source => "/afs/hep.wisc.edu/cms/ops/cron/condor-cm.cron",
    owner => '0',
    group => '0',
    mode => '644',
    checksum => 'md5',
    backup => false;

  }
}
