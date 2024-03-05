# frozen_string_literal: true

# Compares Windows applocker rules.
Puppet::Functions.create_function(:"applocker::compare_rules") do
  # @param rules Existing rules from a host
  # @param desired_rules Desired applocker rules from Puppet manifest.
  # @return [Hash] Returns true if match, if no match, false along with which rule failed to match.
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
    rule_collection = rules['RuleCollection']
    desired_collection = desired_rules['RuleCollection']

    unless rules['RuleCollection'] && desired_rules['RuleCollection']
      # confirm both rules are not empty
      if rule_collection == desired_collection
        return { 'Result' => true }
      end
      # no rules found in one of the hashes
      return { 'Result' => false }
    end

    # Check appx rules
    appx_a = get_rule_section('Appx', rule_collection)
    appx_b = get_rule_section('Appx', desired_collection)
    appx_result = rule_comparison(appx_a, appx_b)

    if appx_result == false
      return { 'Result' => false,
               'failing_rule' => 'Appx' }
    end

    # Check Dll rules
    dll_a = get_rule_section('Dll', rule_collection)
    dll_b = get_rule_section('Dll', desired_collection)
    dll_result = rule_comparison(dll_a, dll_b)

    if dll_result == false
      return { 'Result' => false,
               'failing_rule' => 'Dll' }
    end

    # Check Exe rules
    exe_a = get_rule_section('Exe', rule_collection)
    exe_b = get_rule_section('Exe', desired_collection)
    exe_result = rule_comparison(exe_a, exe_b)

    if exe_result == false
      return { 'Result' => false,
               'failing_rule' => 'Exe', 'exe_a' => exe_a, 'exe_b' => exe_b }
    end

    # Check Msi rules
    msi_a = get_rule_section('Msi', rule_collection)
    msi_b = get_rule_section('Msi', desired_collection)
    msi_result = rule_comparison(msi_a, msi_b)

    if msi_result == false
      return { 'Result' => false,
               'failing_rule' => 'Msi' }
    end

    # Check Script rules
    script_a = get_rule_section('Script', rule_collection)
    script_b = get_rule_section('Script', desired_collection)
    script_result = rule_comparison(script_a, script_b)

    if script_result == false
      return { 'Result' => false,
               'failing_rule' => 'Script' }
    end

    { 'Result' => true }
  end

  def get_rule_section(type, rules)
    rules.each do |element|
      if element['Type'] == type
        return element
      end
    end
  rescue
    { 'EnforcementMode' => 'no_match' }
  end

  def rule_comparison(rule1, rule2)
    matched = false

    # confirm we are not check the same hash
    if rule1.hash == rule2.hash
      return true
    end

    # check enforcement mode
    begin
    if rule1['EnforcementMode'] != rule2['EnforcementMode']
      return false
    end
    rescue
      return false
    end

    # check FilePublisherRule
    if rule1.key?('FilePublisherRule') || rule2.key?('FilePublisherRule')
      begin
        if rule1['FilePublisherRule'].length != rule2['FilePublisherRule'].length
          return false
        end
        rule1['FilePublisherRule'].each do |element|
          rule2['FilePublisherRule'].each do |element2|
            if element == element2
              matched = true
            end
          end
          # confirm each rule matched
          if matched == false
            return false
          end
          matched = false
        end
      rescue
        return false
      end
    end

    # check FilePathRule
    if rule1.key?('FilePathRule') || rule2.key?('FilePathRule')
      begin
        if rule1['FilePathRule'].length != rule2['FilePathRule'].length
          return false
        end
        rule1['FilePathRule'].each do |element|
          rule2['FilePathRule'].each do |element2|
            if element == element2
              matched = true
            end
          end
          # confirm each rule matched
          if matched == false
            return false
          end
          matched = false
        end
      rescue
        return false
      end
    end

    # check FileHashRule.
    if rule1.key?('FileHashRule') || rule2.key?('FileHashRule')
      begin
        if rule1['FileHashRule'].length != rule2['FileHashRule'].length
          return false
        end
        rule1['FileHashRule'].each do |element|
          rule2['FileHashRule'].each do |element2|
            if element == element2
              matched = true
            end
          end
          # confirm each rule matched
          if matched == false
            return false
          end
          matched = false
        end
      rescue
        return false
      end
    end
    # Check if there was a match
    true
  end

  # you can define other helper methods in this code block as well
end
