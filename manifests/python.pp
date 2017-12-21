# @api private
#
# This class is called from the main pulsar class for install.
#
class supervisord::python {
  assert_private('supervisord::python is a private class')

  if $supervisord::manage_python {
    class { '::python':
      dev             => $::supervisord::manage_python_dev,
      manage_gunicorn => false,
      use_epel        => $::supervisord::manage_python_use_epel,
      virtualenv      => $::supervisord::manage_python_virtualenv,
    }
  }
}
