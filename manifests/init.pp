# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include applocker
class applocker (
  Hash $exec_applocker_rules = {},
  Hash $msi_applocker_rules = {},
  Hash $appx_applocker_rules = {},
  Hash $script_applocker_rules = {},
  Hash $dll_applocker_rules = {},
  Enum['Enabled','AuditOnly'] $executable_rules = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $msi_rules = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $dll_rules = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $script_rules = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $packaged_app_rules = 'AuditOnly',
  Boolean $start_service = true,
) {
  # create xml file
  file { 'policy file':
    ensure  => present,
    path    => 'c:\temp\applocker_puppet.xml',
    content => epp('applocker/xmlrule.epp', {
      'exec_applocker_rules'   => $exec_applocker_rules,
      'msi_applocker_rules'    => $msi_applocker_rules,
      'appx_applocker_rules'   => $appx_applocker_rules,
      'script_applocker_rules' => $script_applocker_rules,
      'dll_applocker_rules'    => $dll_applocker_rules,
      'executable_rules'       => $executable_rules,
      'msi_rules'              => $msi_rules,
      'dll_rules'              => $dll_rules,
      'script_rules'           => $script_rules,
      'packaged_app_rules'     => $packaged_app_rules,}),
  }
  # notify{"exec_applocker_rules lenght is ${exec_applocker_rules.length}":}
  # notify{"Applocker rules are ${applocker::xml_tohash($facts['applocker_rules'])}":}
  # $hash_policy = applocker::xml_tohash($facts['applocker_rules'])
  # notify{"applocker hash type ${type($hash_policy)}":}
  # file { 'policy from fact':
  #   ensure  => present,
  #   path    => 'c:\temp\applocker_from_fact.xml',
  #   content => applocker::hash_toxml($hash_policy),
  # }
}
