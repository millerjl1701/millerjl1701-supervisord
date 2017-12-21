# @api private
#
# This class is called from the main supervisord class for install.
#
class supervisord::install {
  assert_private('supervisord::install is a private class')

  file { [ $::supervisord::confdir, "${::supervisord::confdir}/conf.d", ]:
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
