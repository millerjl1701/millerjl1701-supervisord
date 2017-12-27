# Class: supervisord
# ===========================
#
# Main class that includes all other classes for the supervisord module.
#
# @param package_ensure Whether to install the supervisord package, and/or what version. Values: 'present', 'latest', or a specific version number. Default value: present.
# @param package_name Specifies the name of the package to install. Default value: 'supervisord'.
# @param service_enable Whether to enable the supervisord service at boot. Default value: true.
# @param service_ensure Whether the supervisord service should be running. Default value: 'running'.
# @param service_name Specifies the name of the service to manage. Default value: 'supervisord'.
#
class supervisord (
  Boolean                    $manage_python            = true,
  Enum['present', 'absent']  $manage_python_dev        = 'present',
  Boolean                    $manage_python_use_epel   = true,
  Enum['present', 'absent']  $manage_python_virtualenv = 'present',
  String                     $package_ensure           = 'present',
  String                     $package_name             = 'supervisor',
  Boolean                    $service_enable           = true,
  Enum['running', 'stopped'] $service_ensure           = 'running',
  String                     $service_name             = 'supervisord',
  Stdlib::Absolutepath       $supervisord_confdir      = '/etc/supervisor',
  String                     $supervisord_conffile     = 'supervisord.conf',
  Optional[Hash]             $supervisord_ini_absent   = {},
  Optional[Hash]             $supervisord_ini_present  = {},
  Stdlib::Absolutepath       $supervisord_logdir       = '/var/log/supervisor',
  Stdlib::Absolutepath       $supervisord_rundir       = '/var/run/supervisor',
  String                     $virtualenv               = 'system',
  String                     $virtualenv_owner         = 'root',
  ) {
  case $::operatingsystem {
    'RedHat', 'CentOS': {
      contain supervisord::python
      contain supervisord::install
      contain supervisord::config
      contain supervisord::service

      Class['supervisord::python']
      -> Class['supervisord::install']
      -> Class['supervisord::config']
      ~> Class['supervisord::service']
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
