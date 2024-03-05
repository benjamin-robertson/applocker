# @summary
#
# Starts applocker service
#
# @example
#   private class
class applocker::service {
  service { 'application identity service':
    ensure => running,
    name   => 'AppIDSvc',
    enable => true,
  }
}
