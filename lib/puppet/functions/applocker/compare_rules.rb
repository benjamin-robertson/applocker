# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::compare_rules") do
  dispatch :compare_rules do
    param 'Hash', :rules
    param 'Hash', :desired_rules
    return_type 'Hash'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def compare_rules(rules, desired_rules)
    return { 'Result' => true }
    rule_collection = rules['RuleCollection']
    desired_collection = desired_rules['RuleCollection']

    # Check appx rules
    appx_a = get_rule_section('Appx', rule_collection)
    appx_b = get_rule_section('Appx', desired_collection)
    appx_result = compare_rules(appx_a, appx_b)

    if appx_result == false 
      return { 'Result' => false,
               'failing_rule' => 'Appx' }
    end

    # Check Dll rules
    dll_a = get_rule_section('Dll', rule_collection)
    dll_b = get_rule_section('Dll', desired_collection)
    dll_result = compare_rules(dll_a, dll_b)

    if dll_result == false 
      return { 'Result' => false,
               'failing_rule' => 'Dll' }
    end

    # Check Exe rules
    exe_a = get_rule_section('Exe', rule_collection)
    exe_b = get_rule_section('Exe', desired_collection)
    exe_result = compare_rules(exe_a, exe_b)

    if exe_result == false 
      return { 'Result' => false,
               'failing_rule' => 'Exe' }
    end

    # Check Msi rules
    msi_a = get_rule_section('Msi', rule_collection)
    msi_b = get_rule_section('Msi', desired_collection)
    msi_result = compare_rules(msi_a, msi_b)

    if msi_result == false 
      return { 'Result' => false,
               'failing_rule' => 'Msi' }
    end

    # Check Script rules
    script_a = get_rule_section('Script', rule_collection)
    script_b = get_rule_section('Script', desired_collection)
    script_result = compare_rules(script_a, script_b)

    if script_result == false 
      return { 'Result' => false,
               'failing_rule' => 'Script' }
    end

    return { 'Result' => true }

  end

  def get_rule_section(type, rules)
    return_val = {}
    rules.each do | element |
      if element['Type'] == type
        return_val = element
      end
    end
    return_val
  end
  
  def compare_rules(rule1, rule2)
    matched = false
    result = true
  
    # check enforcement mode
    if rule1['EnforcementMode'] != rule2['EnforcementMode']
      result = false
    end
  
    # check FilePublisherRule
    if rule1.key?('FilePublisherRule')
      begin
        rule1['FilePublisherRule'].each do | element |
          rule2['FilePublisherRule'].each do | element2 |
            if element == element2
              matched = true
            end
          end
          # confirm each rule matched
          if matched == false
            result = false
          end
          matched = false
        end
      rescue => exception
        result = false
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
          end
          # confirm each rule matched
          if matched == false
            result = false
          end
          matched = false
        end
      rescue => exception
        result = false
      end
    end
    
    # Check if there was a match
    result
  end

  # you can define other helper methods in this code block as well
end
