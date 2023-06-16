# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::compare_rules") do
  dispatch :compare_rules do
    param 'Hash', :rules
    param 'Hash', :desired_rules
    return_type 'Array'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def compare_rules(rules, desired_rules)
    rule_collection = rules['RuleCollection']
    desired_collection = desired_rules['RuleCollection']

    # Get Appx rules
    # appx_a = get_rule_section('Appx', rule_collection)
    # appx_b = get_rule_section('Appx', desired_collection)

    # Compare Appx rules
    desired_collection
  end

  # def get_rule_section(type, rules)
  #   rules.each do | element |
  #     if element['Type'] == type
  #       return element
  #     end
  #   end
  # end

  # def compare_rules(rule_a, rule_b)
  # end

  # you can define other helper methods in this code block as well
end



# compar workings

def get_rule_section(type, rules)
  rules.each do | element |
    if element['Type'] == type
      return element
    end
  end
end

def compare_rules(rule1, rule2)
  matched = false

  # check enforcement mode
  if rule1['EnforcementMode'] != rule2['EnforcementMode']
    return false
  end

  # check FilePublisherRule
  if rule1.key?('FilePublisherRule')
    begin
      rule1['FilePublisherRule'].each do | element |
        rule2['FilePublisherRule'].each do | element2 |
          if element == element2
            matched = true
          end
          # puts element
          # puts
          # puts element2
        end
        # confirm each rule matched
        if matched == false
          return false
          puts "return false"
        end
        matched == false
      end
    rescue => exception
      return false
    end
  end

  # check FilePathRule
  if rule1.key?('FilePathRule')
    begin
      rule1['FilePathRule'].each do | element |
        rule2['FilePathRule'].each do | element2 |
          if element == element2
            matched = true
          end
          # puts element
          # puts
          # puts element2
        end
        # confirm each rule matched
        if matched == false
          return false
          puts "return false"
        end
        matched == false
      end
    rescue => exception
      return false
    end
  end
  
  # Check if there was a match
  return true
end


rules = [{'Type' => 'Appx', 'EnforcementMode' => 'Enabled', 'FilePublisherRule' => [{'Id' => '081a98ae-63e0-4eb6-a6a7-9659f3022d23', 'Name' => 'Packaged app MS corp windows', 'Description' => 'Allow Package app rule Microsoft corporation (Windows)', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}, {'Id' => '298ca13d-d90f-4fca-b6b5-5a3625490191', 'Name' => 'Packaged app MS corp', 'Description' => 'Allow Package app rule Microsoft corporation', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}]}, {'Type' => 'Dll', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => 'd50b0081-9999-4757-a817-45c4770a0aed', 'Name' => 'DLL %PROGRAMFILES/%', 'Description' => 'Allow dll in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}, {'Id' => 'd8c7140e-14f8-4efc-a0bd-bf59a02cccd0', 'Name' => 'DLL %WINDIR/%', 'Description' => 'Allow dll in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\''}, {'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}]}]}]}, {'Type' => 'Exe', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => '2a4f76b8-98f2-c848-6a0d-8419e349e70e', 'Name' => 'Exec %OSDRIVE/CHOCO/%', 'Description' => 'Allow all users to run apps in osdrive choco', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%OSDRIVE%\CHOCO\*'}]}]}, {'Id' => '44a18050-9156-ec05-8d80-4b8e4e6a6a5b', 'Name' => 'Exec %windir/%', 'Description' => 'Allow all users to run apps in windir', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}, {'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\*'}]}]}, {'Id' => 'af1b16a6-286a-e335-7b6a-cbbc46dec587', 'Name' => 'Exec %%PROGRAMFILES/%', 'Description' => 'Allow all users to run apps in programfiles', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}]}, {'Type' => 'Msi', 'EnforcementMode' => 'Enabled', 'FilePublisherRule' => [{'Id' => '5757eb6c-83ad-4e8e-97c2-3acee403385d', 'Name' => 'MSI rule MS corp windows', 'Description' => 'Allow Package app rule Microsoft corporation (Windows)', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}, {'Id' => 'f393310f-fa05-4444-bdcb-3860a5f0875b', 'Name' => 'MSI rule MS corp', 'Description' => 'Allow Package app rule Microsoft corporation', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}]}, {'Type' => 'Script', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => '3fb0a03d-e720-43ae-b3ea-7821c28c9bc3', 'Name' => 'Script %PROGRAMFILES/%', 'Description' => 'Allow scripts in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}, {'Id' => '8aecd509-39a1-4bec-ac6e-d60727cc6631', 'Name' => 'Script %WINDIR/%', 'Description' => 'Allow scripts in the windir directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%SYSTEM32%\Com\dmp\*'}, {'Path' => '%SYSTEM32%\FxsTmp\*'}, {'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}, {'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\spool\PRINTERS\*'}, {'Path' => '%SYSTEM32%\spool\SERVERS\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Registration\CRMLog\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\*'}, {'Path' => '%WINDIR%\tracing\*'}]}]}]}]

desired_rules = [{'Type' => 'Appx', 'EnforcementMode' => 'Enabled', 'FilePublisherRule' => [{'Id' => '298ca13d-d90f-4fca-b6b5-5a3625490191', 'Name' => 'Packaged app MS corp', 'Description' => 'Allow Package app rule Microsoft corporation', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}, {'Id' => '081a98ae-63e0-4eb6-a6a7-9659f3022d23', 'Name' => 'Packaged app MS corp windows', 'Description' => 'Allow Package app rule Microsoft corporation (Windows)', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}]}, {'Type' => 'Dll', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => 'd50b0081-9999-4757-a817-45c4770a0aed', 'Name' => 'DLL %PROGRAMFILES/%', 'Description' => 'Allow dll in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}, {'Id' => 'd8c7140e-14f8-4efc-a0bd-bf59a02cccd0', 'Name' => 'DLL %WINDIR/%', 'Description' => 'Allow dll in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\\'}, {'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}]}]}]}, {'Type' => 'Exe', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => '44a18050-9156-ec05-8d80-4b8e4e6a6a5b', 'Name' => 'Exec %windir/%', 'Description' => 'Allow all users to run apps in windir', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}, {'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\*'}]}]}, {'Id' => 'af1b16a6-286a-e335-7b6a-cbbc46dec587', 'Name' => 'Exec %%PROGRAMFILES/%', 'Description' => 'Allow all users to run apps in programfiles', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}, {'Id' => '2a4f76b8-98f2-c848-6a0d-8419e349e70e', 'Name' => 'Exec %OSDRIVE/CHOCO/%', 'Description' => 'Allow all users to run apps in osdrive choco', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%OSDRIVE%\CHOCO\*'}]}]}, {'Id' => '44fa83d3-e230-a700-bbd1-340369fcbec1', 'Name' => 'Exec %OSDRIVE/temp/%', 'Description' => 'Allow all users to run apps in osdrive temp', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%OSDRIVE%\temp\*'}]}]}]}, {'Type' => 'Msi', 'EnforcementMode' => 'Enabled', 'FilePublisherRule' => [{'Id' => 'f393310f-fa05-4444-bdcb-3860a5f0875b', 'Name' => 'MSI rule MS corp', 'Description' => 'Allow Package app rule Microsoft corporation', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}, {'Id' => '5757eb6c-83ad-4e8e-97c2-3acee403385d', 'Name' => 'MSI rule MS corp windows', 'Description' => 'Allow Package app rule Microsoft corporation (Windows)', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePublisherCondition' => [{'PublisherName' => 'CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US', 'ProductName' => '*', 'BinaryName' => '*', 'BinaryVersionRange' => [{'LowSection' => '*', 'HighSection' => '*'}]}]}]}]}, {'Type' => 'Script', 'EnforcementMode' => 'Enabled', 'FilePathRule' => [{'Id' => '8aecd509-39a1-4bec-ac6e-d60727cc6631', 'Name' => 'Script %WINDIR/%', 'Description' => 'Allow scripts in the windir directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%WINDIR%\*'}]}], 'Exceptions' => [{'FilePathCondition' => [{'Path' => '%SYSTEM32%\Com\dmp\*'}, {'Path' => '%SYSTEM32%\FxsTmp\*'}, {'Path' => '%System32%\Microsoft\Crypto\RSA\MachineKeys\*'}, {'Path' => '%SYSTEM32%\spool\drivers\color\*'}, {'Path' => '%SYSTEM32%\spool\PRINTERS\*'}, {'Path' => '%SYSTEM32%\spool\SERVERS\*'}, {'Path' => '%SYSTEM32%\Tasks\*'}, {'Path' => '%WINDIR%\Registration\CRMLog\*'}, {'Path' => '%WINDIR%\Tasks\*'}, {'Path' => '%WINDIR%\Temp\*'}, {'Path' => '%WINDIR%\tracing\*'}]}]}, {'Id' => '3fb0a03d-e720-43ae-b3ea-7821c28c9bc3', 'Name' => 'Script %PROGRAMFILES/%', 'Description' => 'Allow scripts in the programfiles directory', 'UserOrGroupSid' => 'S-1-1-0', 'Action' => 'Allow', 'Conditions' => [{'FilePathCondition' => [{'Path' => '%PROGRAMFILES%\*'}]}]}]}]

# Get appx rules
appx_a = get_rule_section('Appx', rules)
appx_b = get_rule_section('Appx', desired_rules)

appx_result = compare_rules(appx_a, appx_b)
puts "Appx matches #{appx_result}"

# Get Dll rules
dll_a = get_rule_section('Dll', rules)
dll_b = get_rule_section('Dll', desired_rules)

dll_result = compare_rules(dll_a, dll_b)
puts "Dll matches #{dll_result}"

# Check exe rules
exe_a = get_rule_section('Exe', rules)
exe_b = get_rule_section('Exe', desired_rules)

exe_result = compare_rules(exe_a, exe_b)
puts "Exe matches #{exe_result}"