# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::extract_rules") do
  dispatch :extract_rules do
    param 'Hash', :rules
    return_type 'Hash'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def extract_rules(rules)
    rules['RuleCollection'].each do |index, array|
      puts "index is #{index} array is #{array}"
    end
  end

  # you can define other helper methods in this code block as well
end
