class apache {
if $facts['os']['name'] == 'Ubuntu' {
  $apache_name = 'apache2'
  $vhost_conf = '/etc/apache2/sites-available/server.conf'
} elsif $facts['os']['name'] == 'Centos' {
  $apache_name = 'httpd'
  $vhost_conf = '/etc/httpd/conf.d/server.conf'
}

  package { 'apache':
    ensure => present,
    name => $apache_name, 
  }
  notify { "$apache_name is installed.":
  }

  service { 'apache':
        ensure => 'running',
        name => $apache_name,
        require => Package['apache'],
  }

  notify { "$apache_name is running.":
  }

  $apache_hash = {
    'apache_name' => $apache_name,
  }
  file { $vhost_conf:
    content => epp('apache/server.epp', $apache_hash),
    require => Package['apache'],
    notify  => Service['apache'],
  }

}
