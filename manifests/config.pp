# @api private
#
# This class is called from supervisord for service config.
#
class supervisord::config {
  assert_private('supervisord::config is a private class')

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

  if $::supervisord::supervisord_ini_absent {
    $_ini_absent = $::supervisord::supervisord_ini_absent
    $_ini_absent.each |String $_absent_section, Hash $_absent_settings| {
      $_absent_settings.each |String $_absent_setting, String $_absent_value| {
        ini_setting { "${_absent_section} ${_absent_setting}":
          ensure  => absent,
          path    => "${::supervisord::supervisord_confdir}/${::supervisord::supervisord_conffile}",
          section => $_absent_section,
          setting => $_absent_setting,
          value   => $_absent_value,
        }
      }
    }
  }

  if $::supervisord::manage_systemd_unit {
    include ::systemd::systemctl::daemon_reload
    $_after      = $::supervisord::supervisord_systemd_after
    $_binpath    = $::supervisord::supervisord_binpath
    $_confdir    = $::supervisord::supervisord_confdir
    $_conffile   = $::supervisord::supervisord_conffile
    $_ctlpath    = $::supervisord::supervisord_ctlpath
    $_killmode   = $::supervisord::supervisord_systemd_killmode
    $_restart    = $::supervisord::supervisord_systemd_restart
    $_restartsec = $::supervisord::supervisord_systemd_restartsec
    $_type       = $::supervisord::supervisord_systemd_type
    file { '/etc/systemd/system/supervisord.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template($::supervisord::supervisord_systemd_template),
    } ~> Class['systemd::systemctl::daemon_reload']
  }
}
