class puppet (
  $minute = '*/15',
  $hour = '*',
  $monthday = '*',
  $month = '*',
  $weekday = '*'
) {
  $required = $::operatingsystem ? {
    /(?i-mx:centos|fedora|redhat|scientific)/ => 'puppet',
  }

  package { $required: ensure => latest }

  cron { 'puppet':
    command  => '/etc/puppet/apply.sh > /dev/null 2>&1',
    user     => root,
    minute   => $minute,
    hour     => $hour,
    monthday => $monthday,
    month    => $month,
    weekday  => $weekday,
  }

  cron { 'reports':
    command  => '/usr/local/sbin/reports.sh > /dev/null 2>&1',
    user     => root,
    minute   => '0',
    hour     => '0',
    require  => File['/usr/local/sbin/reports.sh'],
  }

  file { '/usr/local/sbin/reports.sh':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/puppet/reports.sh'
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
