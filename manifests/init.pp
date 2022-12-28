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
    ensure   => present,
    path     => 'c:\temp\applocker_puppet.xml',
    contents => epp('applocker\xmlrule.epp', {
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
}
