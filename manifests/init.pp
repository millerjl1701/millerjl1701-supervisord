# Class: supervisord
# ===========================
#
# Main class that includes all other classes for the supervisord module.
#
# @param manage_python Whether or not to have the module manage python using the stankevich-python module.
# @param manage_python_dev Desired state of the python-dev package passed to python class from stankevich-python module.
# @param manage_python_use_epel Whether or not to use epel passed to python class from stankevich-python module.
# @param manage_python_virtualenv Desired state of the virtualenv package passed to python class from stankevich-python module.
# @param manage_service Whether or not to manage the supervisord service with this module.
# @param manage_systemd_unit Whether or not to manage the systemd unit for supervisord.service with this module.
# @param package_ensure Whether to install the supervisord package, and/or what version. Suggested values: 'present', 'latest', or a specific version number.
# @param package_name Specifies the name of the package to install.
# @param service_enable Whether to enable the supervisord service at boot.
# @param service_ensure Whether the supervisord service should be running.
# @param service_name Specifies the name of the service to manage.
# @param supervisord_binpath Path to the supervisord binary. Defaults to location if installed to system.
# @param supervisord_confdir Configuration directory to use for the supervisord service.
# @param supervisord_conffile Configuration file name to use for the supercisord service.
# @param supervisord_ctlpath Path to the supervisorctl binary. Defaults to location if installed to system.
# @param supervisord_ini_absent INI Settings in supervisord.conf that should be removed if present.
# @param supervisord_ini_present INI Settings in supervisord.conf that should replace default settings or be added as new settings.
# @param supervisord_logdir Log directory for the supervisord service.
# @param supervisord_rundir Run-time files directory for the supervisord service.
# @param supervisord_systemd_after Systemd units to append after network.target so that they start before supervisord.
# @param supervisord_systemd_killmode Specifies how systemd should kill the processes of the supervisord unit.
# @param supervisord_systemd_restart Configures whether the service shall be restarted when the service process exits, is killed, or a timeout is reached.
# @param supervisord_systemd_restartsec Configures the time to sleep before restarting a service.
# @param supervisord_systemd_template Template for puppet to use to create the supervisord.service file.
# @param supervisord_systemd_type Configures the process start-up type for the supervisord.service unit.
# @param virtualenv Which virtualenv to install supervisor.
# @param virtualenv_owner User that should own and run the supervisor daemon.
#
class supervisord (
  Boolean                    $manage_python                  = true,
  Enum['present', 'absent']  $manage_python_dev              = 'present',
  Boolean                    $manage_python_use_epel         = true,
  Enum['present', 'absent']  $manage_python_virtualenv       = 'present',
  Boolean                    $manage_service                 = true,
  Boolean                    $manage_systemd_unit            = true,
  String                     $package_ensure                 = 'present',
  String                     $package_name                   = 'supervisor',
  Boolean                    $service_enable                 = true,
  Enum['running', 'stopped'] $service_ensure                 = 'running',
  String                     $service_name                   = 'supervisord',
  Stdlib::Absolutepath       $supervisord_binpath            = '/usr/bin/supervisord',
  Stdlib::Absolutepath       $supervisord_confdir            = '/etc/supervisor',
  String                     $supervisord_conffile           = 'supervisord.conf',
  Stdlib::Absolutepath       $supervisord_ctlpath            = '/usr/bin/supervisorctl',
  Optional[Hash]             $supervisord_ini_absent         = {},
  Optional[Hash]             $supervisord_ini_present        = {},
  Stdlib::Absolutepath       $supervisord_logdir             = '/var/log/supervisor',
  Stdlib::Absolutepath       $supervisord_rundir             = '/var/run/supervisor',
  Optional[Array]            $supervisord_systemd_after      = [],
  String                     $supervisord_systemd_killmode   = 'process',
  String                     $supervisord_systemd_restart    = 'on-failure',
  String                     $supervisord_systemd_restartsec = '50s',
  String                     $supervisord_systemd_template   = 'supervisord/supervisord.service.erb',
  String                     $supervisord_systemd_type       = 'forking',
  String                     $virtualenv                     = 'system',
  String                     $virtualenv_owner               = 'root',
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
