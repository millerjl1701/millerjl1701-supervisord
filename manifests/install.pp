# @api private
#
# This class is called from the main supervisord class for install.
#
class supervisord::install {
  assert_private('supervisord::install is a private class')

  file { [
    $::supervisord::supervisord_confdir,
    "${::supervisord::supervisord_confdir}/conf.d",
    $::supervisord::supervisord_logdir,
    $::supervisord::supervisord_rundir,
  ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  python::pip { $::supervisord::package_name:
    pkgname    => $::supervisord::package_name,
    ensure     => $::supervisord::package_ensure,
    virtualenv => $::supervisord::virtualenv,
    owner      => $::supervisord::virtualenv_owner,
  }
}
