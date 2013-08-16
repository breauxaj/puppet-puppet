class puppet {
  $required = $operatingsystem ? {
    /(?i-mx:centos|fedora|redhat|scientific)/ => [ 'augeas-libs', 'facter', 'puppet', 'ruby', 'ruby-rdoc', 'rubygems' ],
  }

  package { $required: ensure => latest }

  file { '/etc/cron.d/puppet':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet/puppet.cron'
  }
    
  file { '/etc/puppet':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0700',
  }
    
  add_group { 'puppet': gid => 52 }
    
  add_service { 'puppet': gid => 52, groups => '', uid => 52 }

}
