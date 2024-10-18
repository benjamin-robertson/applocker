# @summary Installs XML simple gem on primary server
#
# @example
#   include applocker::primary::gem_installer
class applocker::primary::gem_installer {
  package { 'xml-simple':
    ensure   => 'present',
    provider => 'puppetserver_gem',
  }
}
