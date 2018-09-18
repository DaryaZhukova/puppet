class zabbix_agent {

  $zserver = '192.168.17.2'
  $zport   = '10050'

  package { 'zabbix_agent':
    name   => 'zabbix-agent',
    ensure => present,
  }

  $zabbix_hash = {
    'zserver' => $zserver,
    'zport'   => $zport,
  }
  file { '/etc/zabbix/zabbix_agentd.conf':
    content => epp('zabbix_agent/agentd.epp', $zabbix_hash),
    require => Package['zabbix_agent'],
    notify  => Service['zabbix-agent'],
  }

  service { 'zabbix-agent':
    ensure  => 'running',
    enable  => true,
    require => Package['zabbix_agent'],
  }
}
