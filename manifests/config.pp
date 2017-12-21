# @api private
#
# This class is called from supervisord for service config.
#
class supervisord::config {
  assert_private('supervisord::config is a private class')
}
