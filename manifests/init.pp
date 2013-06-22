class composer {

  $composer_command_name = 'composer'

  exec { 'composer-install':
    command => "wget -O ${composer_command_name} ${::composer::params::phar_location}",
    cwd     => $boxen::config::bindir,
    unless  => "test -f ${boxen::config::bindir}/${composer_command_name}",
  }

  exec { 'composer-fix-permissions':
    command => "chmod a+x ${composer_command_name}",
    cwd     => $boxen::config::bindir,
    unless  => "test -x ${composer_target_dir}/${composer_command_name}",
    require => Exec['composer-install'],
  }

  if $auto_update {
    exec { 'composer-update':
      command => "${composer_command_name} self-update",
      path    => $boxen::config::bindir,
      require => Exec['composer-fix-permissions'],
    }
  }

}
