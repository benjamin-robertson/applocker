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
    # rule_collection = rules['RuleCollection']
    desired_collection = desired_rules['RuleCollection']
    desired_collection_sorted = desired_collection.sort
    desired_collection
  end

  # you can define other helper methods in this code block as well
end
