class puppet (
  interval = '*/15'
) {
  $required = $::operatingsystem ? {
    /(?i-mx:centos|fedora|redhat|scientific)/ => 'puppet',
  }

  package { $required: ensure => latest }

  cron { 'puppet':
    command => '/etc/puppet/apply.sh > /dev/null 2>&1',
    user    => root,
    minute  => $interval,
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
