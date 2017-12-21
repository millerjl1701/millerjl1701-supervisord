node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'supervisord':
    require => Notify['enduser-before'],
    before  => Notify['enduser-after'],
  }

}
