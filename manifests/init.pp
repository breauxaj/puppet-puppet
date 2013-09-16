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
  
  group { 'puppet':
    ensure => present,
    gid    => 52,
  }

  user { 'puppet':
    ensure     => present,
    gid        => 52,
    home       => '/var/lib/puppet',
    shell      => '/sbin/nologin',
    managehome => true,
    uid        => 52,
  }

}
