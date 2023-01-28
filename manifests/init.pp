# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# lint:ignore:140chars
# @example
#   include applocker
class applocker (
  Hash                        $exec_applocker_rules   = {},
  Hash                        $msi_applocker_rules    = {},
  Hash                        $appx_applocker_rules   = {},
  Hash                        $script_applocker_rules = {},
  Hash                        $dll_applocker_rules    = {},
  Enum['Enabled','AuditOnly'] $executable_rules       = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $msi_rules              = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $dll_rules              = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $script_rules           = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $packaged_app_rules     = 'AuditOnly',
  Boolean                     $purge_existing_rules   = true,
  Boolean                     $start_service          = true,
) {
  #notify{"exec_applocker_rules lenght is ${exec_applocker_rules.length}":}
  #notify{"Applocker rules are ${applocker::xml_tohash($facts['applocker_rules'])}":}
  $hash_policy = applocker::xml_tohash($facts['applocker_rules'])
  #notify{"applocker hash type ${type($hash_policy)}":}
  # file { 'policy from fact':
  #   ensure  => present,
  #   path    => 'c:\temp\applocker_from_fact.xml',
  #   content => applocker::hash_toxml($hash_policy),
  # }

  # Break down structure using function, We want to retrieve all the names of each rules type and return
  $rule_results = applocker::extract_rules($hash_policy)
  #notify{"rule results ${rule_results}":}

  # Generate id for each rule, or get from existing rule. 
  $exec_applocker_rules_with_id = applocker::get_id($exec_applocker_rules, $rule_results['name_to_id'])
  $msi_applocker_rules_with_id = applocker::get_id($msi_applocker_rules, $rule_results['name_to_id'])
  $appx_applocker_rules_with_id = applocker::get_id($appx_applocker_rules, $rule_results['name_to_id'])
  $script_applocker_rules_with_id = applocker::get_id($script_applocker_rules, $rule_results['name_to_id'])
  $dll_applocker_rules_with_id = applocker::get_id($dll_applocker_rules, $rule_results['name_to_id'])
  # notify{"exec with id ${$exec_applocker_rules_with_id}":}
  # notify{"msi with id ${$msi_applocker_rules_with_id}":}
  # notify{"appx with id ${$appx_applocker_rules_with_id}":}
  # notify{"script with id ${$script_applocker_rules_with_id}":}
  # notify{"dll with id ${$dll_applocker_rules_with_id}":}

  # create xml file
  file { 'policy file':
    ensure  => present,
    path    => 'c:\temp\applocker_puppet.xml',
    content => epp('applocker/xmlrule.epp', {
      'exec_applocker_rules'   => $exec_applocker_rules_with_id,
      'msi_applocker_rules'    => $msi_applocker_rules_with_id,
      'appx_applocker_rules'   => $appx_applocker_rules_with_id,
      'script_applocker_rules' => $script_applocker_rules_with_id,
      'dll_applocker_rules'    => $dll_applocker_rules_with_id,
      'executable_rules'       => $executable_rules,
      'msi_rules'              => $msi_rules,
      'dll_rules'              => $dll_rules,
      'script_rules'           => $script_rules,
      'packaged_app_rules'     => $packaged_app_rules,}),
  }
}
# lint:endignore
