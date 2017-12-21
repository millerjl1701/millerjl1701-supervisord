# @api private
#
# This class is called from the main supervisord class for install.
#
class supervisord::install {
  assert_private('supervisord::install is a private class')

  python::pip { $::supervisord::package_name:
    pkgname    => $::supervisord::package_name,
    ensure     => $::supervisord::package_ensure,
    virtualenv => $::supervisord::virtualenv,
    owner      => $::supervisord::virtualenv_owner,
  }
}
