# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# lint:ignore:140chars
# @example
#   include applocker
# Struct[{ 'action' => Enum['Allow','Deny'],
#         'ensure' => Variant[String, Optional],
#         'conditions' => Variant[Hash, Array],
#         'exceptions' => Variant[Hash, Array, Optional],
#         'description' => Variant[String, Optional],
#         'rule_type' => Enum['path','hash','publisher'],
#         'type'        => Variant[String, Optional],
#         'user_or_group_sid' => String,}]
class applocker (
  Hash                        $exec_applocker_rules   = {},
  # Struct[{ 'action'         => Enum['Allow','Deny'],
  #     'ensure'            => Variant[String, Optional],
  #     'conditions'        => Variant[Hash, Array],
  #     'exceptions'        => Variant[Hash, Array, Optional],
  #     'description'       => Variant[String, Optional],
  #     'rule_type'         => Enum['path','hash','publisher'],
  #     'type'              => Variant[String, Optional],
  # 'user_or_group_sid' => String }] $exec_applocker_rules = {},
  Hash                        $msi_applocker_rules    = {},
  Hash                        $appx_applocker_rules   = {},
  Hash                        $script_applocker_rules = {},
  Hash                        $dll_applocker_rules    = {},
  Enum['Enabled','AuditOnly'] $executable_rules       = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $msi_rules              = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $dll_rules              = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $script_rules           = 'AuditOnly',
  Enum['Enabled','AuditOnly'] $packaged_app_rules     = 'AuditOnly',
  Boolean                     $start_service          = true,
) {
  $hash_policy = applocker::xml_tohash($facts['applocker_rules'])

  # Break down structure using function, We want to retrieve all the names of each rules type and return
  $rule_results = applocker::extract_rules($hash_policy)

  # Check if we have any rules set
  $rule_results_final = defined('$rule_results[\'name_to_id\']') ? {
    true    => $rule_results['name_to_id'],
    default => {},
  }

  # Generate id for each rule, or get from existing rule. 
  $exec_applocker_rules_with_id = applocker::get_id($exec_applocker_rules, $rule_results_final)
  $msi_applocker_rules_with_id = applocker::get_id($msi_applocker_rules, $rule_results_final)
  $appx_applocker_rules_with_id = applocker::get_id($appx_applocker_rules, $rule_results_final)
  $script_applocker_rules_with_id = applocker::get_id($script_applocker_rules, $rule_results_final)
  $dll_applocker_rules_with_id = applocker::get_id($dll_applocker_rules, $rule_results_final)

  # create xml file
  file { 'policy file':
    ensure  => file,
    path    => 'c:\windows\applocker_puppet_policy.xml',
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
    'packaged_app_rules'         => $packaged_app_rules, }),
  }
  $proposed_rules = applocker::xml_tohash(epp('applocker/xmlrule.epp', {
        'exec_applocker_rules'   => $exec_applocker_rules_with_id,
        'msi_applocker_rules'    => $msi_applocker_rules_with_id,
        'appx_applocker_rules'   => $appx_applocker_rules_with_id,
        'script_applocker_rules' => $script_applocker_rules_with_id,
        'dll_applocker_rules'    => $dll_applocker_rules_with_id,
        'executable_rules'       => $executable_rules,
        'msi_rules'              => $msi_rules,
        'dll_rules'              => $dll_rules,
        'script_rules'           => $script_rules,
  'packaged_app_rules'           => $packaged_app_rules, }))

  $rule_check_results = applocker::compare_rules($hash_policy, $proposed_rules)
  if $rule_check_results['Result'] == false {
    notify { "Rules don\'t match. Results ${rule_check_results}": }
    exec { 'Update applocker rules':
      path    => 'C:/Windows/System32/WindowsPowerShell/v1.0',
      command => 'powershell Set-AppLockerPolicy -XMLPolicy c:\windows\applocker_puppet_policy.xml',
    }
  }

  if $start_service {
    include applocker::service
  }

  file { 'c:\temp\policies':
    ensure  => directory,
    recurse => true,
  }
  file { 'c:\temp\policies\facts.txt':
    ensure  => file,
    content => "${hash_policy['RuleCollection']}",
  }
  file { 'c:\temp\policies\template.txt':
    ensure  => file,
    content => "${proposed_rules['RuleCollection']}",
  }
}
# lint:endignore
