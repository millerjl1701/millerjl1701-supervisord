# @api private
#
# This class is meant to be called from supervisord to manage the supervisord service.
#
class supervisord::service {
  assert_private('supervisord::service is a private class')

  service { $::supervisord::service_name:
    ensure     => $::supervisord::service_ensure,
    enable     => $::supervisord::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
