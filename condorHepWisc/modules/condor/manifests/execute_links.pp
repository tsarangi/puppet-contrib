define condor::execute_links ($linkcase) {

  case $linkcase {
    'var','default' : {
      file {"${name}_executelinks" :
        path => "/var/condor/.execute-links/${name}",
        ensure => link,
        target => "/var/condor/execute",
      }
    }
    'data0' :{
      file {"${name}_executelinks" :
        path => "/var/condor/.execute-links/${name}",
        ensure => link,
        target => "/data0/condor/execute",
      }
    }
    'data1' :{
      file {"${name}_executelinks" :
        path => "/var/condor/.execute-links/${name}",
        ensure => link,
        target => "/data1/condor/execute",
      }
    }
  }
}
  
