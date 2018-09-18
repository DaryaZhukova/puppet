class zabbix {
  $dbhost     = 'localhost'
  $dbname     = 'zabbix'
  $dbuser     = 'zabbix'
  $dbpassword = 'zabbix'
  $baseurl    = 'http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/'
  $gpgkey     = 'http://repo.zabbix.com/zabbix-official-repo.key'

  file { "zabbixserver-repository":
    path    => "/etc/yum.repos.d/zabbix.repo",
    content => template('zabbix/zabbix.repo.erp'),
  }

  package { 'zabbix_server':
    ensure => present,
    name   => zabbix-server-mysql,
  }
  package { 'zabbix_web':
    ensure => present,
    name   => zabbix-web-mysql,
  }
  $zabbix_hash = {
    'dbhost'     => $dbhost,
    'dbname'     => $dbname,
    'dbuser'     => $dbuser,
    'dbpassword' => $dbpassword,
  }
  file { '/etc/zabbix/zabbix_server.conf':
    content => epp('zabbix/server.epp', $zabbix_hash),
    require => Package['zabbix_server'],
  }

  file { '/etc/zabbix/web/zabbix.conf.php':
    content => epp('zabbix/webserver.epp', $zabbix_hash),
    require => Package['zabbix_web'],
  }
  service { 'zabbix-server':
    ensure  => 'running',
    require => File['/etc/zabbix/zabbix_server.conf', '/etc/zabbix/web/zabbix.conf.php'],
  }

  file_line { 'Replace a line to zabbix.conf':
    path    => '/etc/httpd/conf.d/zabbix.conf',  
    line    => 'php_value date.timezone Europe/Minsk',
    match   => ".*Riga.*",
    require => Package['zabbix_web', 'zabbix_server'],
    notify  => Service['httpd'],
  }

  file_line { 'Replace a line to httpd.conf':
    path    => '/etc/httpd/conf/httpd.conf',
    line    => 'DocumentRoot "/usr/share/zabbix"',
    match   => "^DocumentRoot.*\/var\/www\/html.*",
    require => Package['zabbix_web', 'zabbix_server'],
    notify  => Service['httpd'],
}

  service { 'httpd':
    ensure  => 'running',
    require => Package['zabbix_web', 'zabbix_server'],
  }
}
