group { 'file_group':
  ensure => 'present',
 }

user { 'file_user':
  ensure => 'present',
 }

file { '/tmp/my_files':
  ensure  => 'directory',
  require => User['file_user'],
}

file { 'file1.txt':
  path    => '/tmp/my_files/file1.txt',
  owner   => 'root', 
  ensure  => file,
  group   =>'file_group',
  require => File['/tmp/my_files'],
}
file { 'file2.txt':
  path    => '/tmp/my_files/file2.txt',
  owner   => 'file_user', 
  ensure  => file,
  group   =>'file_group',
  require => File['/tmp/my_files'],
}

