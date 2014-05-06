class osg_ce_condor::install inherits osg_ce_condor {

  # We depend on yum priorities to select the right repo
  # Disable for now, as it's also in osg-ce
  #package { 'yum-plugin-priorities':
  #  ensure  => present,
    #name    => 'yum-plugin-priorities',
  #}

  # Ask for condor, otherwise we might get empty-condor
  package { 'condor':
    ensure  => latest,
    #require => Package['yum-plugin-priorities'],
  }

  package { 'htcondor-ce':
    ensure  => latest,
    require => Package['condor'],
  }

  # Install condor-ce-$RMS
  package { $osg_ce_condor::rms:
    ensure  => latest,
    require => Package['htcondor-ce'],
  }

  package { 'lcas-lcmaps-gt4-interface':
    ensure => present,
  }

  package { 'blahp':
    ensure => latest,
    require => Package['htcondor-ce'],
  }

}
