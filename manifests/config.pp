# @api private
#
# This class is called from supervisord for service config.
#
class supervisord::config {
  assert_private('supervisord::config is a private class')

  include ::systemd::systemctl::daemon_reload

  $default_inisettings = {
    'unix_http_server'        =>
      { 'file' => "${::supervisord::supervisord_rundir}/supervisor.sock" },
    'supervisord'             =>
      {
        'logfile'          => "${::supervisord::supervisord_logdir}/supervisord.log",
        'logfile_maxbytes' => '50MB',
        'logfile_backups'  => '10',
        'loglevel'         => 'info',
        'pidfile'          => "${::supervisord::supervisord_rundir}/supervisord.pid",
        'nodaemon'         => 'false',
        'minfds'           => '1024',
        'minprocs'         => '200',
      },
    'rpcinterface:supervisor' =>
      {
        'supervisor.rpcinterface_factory' => 'supervisor.rpcinterface:make_main_rpcinterface',
      },
    'supervisorctl'           =>
      {
        'serverurl' => "unix://${::supervisord::supervisord_rundir}/supervisor.sock",
      },
    'include'                 =>
      {
        'files' => "${::supervisord::supervisord_confdir}/conf.d/*.conf",
      },
  }

  if $::supervisord::supervisord_ini_present {
    $_ini_present = deep_merge( $default_inisettings, $::supervisord::supervisord_ini_present)
  }
  else {
    $_ini_present = $default_inisettings
  }

  file { "${::supervisord::supervisord_confdir}/${::supervisord::supervisord_conffile}":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  $_ini_present.each |String $_section, Hash $_settings| {
    $_settings.each |String $_setting, String $_value| {
      ini_setting { "${_section} ${_setting}":
        ensure  => present,
        path    => "${::supervisord::supervisord_confdir}/${::supervisord::supervisord_conffile}",
        section => $_section,
        setting => $_setting,
        value   => $_value,
      }
    }
  }

  file { '/etc/systemd/system/supervisord.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('supervisord/supervisord.service.erb'),
  } ~> Class['systemd::systemctl::daemon_reload']
}
