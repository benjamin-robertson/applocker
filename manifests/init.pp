# @summary Set applocker rules for windows
#
# Configures applocker rules for windows. See readme on how to structure applocker rules.
#
# lint:ignore:140chars
# @param exec_applocker_rules Exec applocker rules to configure. 
# @param msi_applocker_rules msi applocker rules to configure.
# @param appx_applocker_rules Packaged app rules to configure.
# @param script_applocker_rules scipt applocker rules to configure.
# @param dll_applocker_rules dll applocker rules to configure.
# @param executable_rules Mode for executable rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.
# @param msi_rules Mode for msi rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.
# @param dll_rules Mode for dll rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.
# @param script_rules Mode for script rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.
# @param packaged_app_rules Mode for packaged app rules, Enum['Enabled','AuditOnly'] Default: AuditOnly.
# @param start_service Whether to start the applocker service. Default: true
# @example
#  include applocker
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
  Boolean                     $start_service          = true,
) {
  $hash_policy = applocker::xml_tohash($facts['applocker_rules'])

  # Break down structure using function, We want to retrieve all the names of each rules type and return
  $rule_results = applocker::extract_rules($hash_policy)

  # Check if we have any rules set
  $rule_results_final = $rule_results.dig('name_to_id') ? {
    undef   => {},
    default => $rule_results['name_to_id'],
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
    path    => 'c:\\windows\\\applocker_puppet_policy.xml',
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

  # Verify applocker policy defined by user is valid.
  exec { 'Verify applocker policy failed':
    path    => 'C:/Windows/System32/WindowsPowerShell/v1.0',
    command => 'powershell Test-AppLockerPolicy -XmlPolicy c:\\windows\\applocker_puppet_policy.xml -path C:\\windows\\notepad.exe',
    unless  => 'powershell Test-AppLockerPolicy -XmlPolicy c:\\windows\\applocker_puppet_policy.xml -path C:\\windows\\notepad.exe',
    require => File['policy file'],
  }

  $rule_check_results = applocker::compare_rules($hash_policy, $proposed_rules)
  if $rule_check_results['Result'] == false {
    notify { "Rules don\'t match. Results ${rule_check_results}": }
    exec { 'Update applocker rules':
      path    => 'C:/Windows/System32/WindowsPowerShell/v1.0',
      command => 'powershell Set-AppLockerPolicy -XMLPolicy c:\\windows\\applocker_puppet_policy.xml',
      onlyif  => 'powershell Test-AppLockerPolicy -XmlPolicy c:\\windows\\applocker_puppet_policy.xml -path C:\\windows\\notepad.exe',
      require => File['policy file'],
    }
  }

  if $start_service {
    include applocker::service
  }

  file { 'c:\temp':
    ensure => directory,
  }

  file { 'c:\temp\policies':
    ensure  => directory,
  }
}
# lint:endignore
