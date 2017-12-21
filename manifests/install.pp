# @api private
#
# This class is called from the main supervisord class for install.
#
class supervisord::install {
  assert_private('supervisord::install is a private class')

  package { $::supervisord::package_name:
    ensure => $::supervisord::package_ensure,
  }
}
