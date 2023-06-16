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
    rule_collection = rules['RuleCollection']
    desired_collection = desired_rules['RuleCollection']

    # Get Appx rules
    appx_a = get_rule_section('Appx', rule_collection)
    appx_b = get_rule_section('Appx', desired_collection)

    # Compare Appx rules
    appx_a
  end

  def get_rule_section(type, rules)
    rules.each do | element |
      if element['Type'] == type
        return element
      end
    end
  end

  def compare_rules(rule_a, rule_b)
  end

  # you can define other helper methods in this code block as well
end
