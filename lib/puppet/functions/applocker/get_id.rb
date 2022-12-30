# frozen_string_literal: true

require 'securerandom'

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::get_id") do
  dispatch :get_id do
    param 'Hash', :applocker_rules
    param 'Hash', :name_to_id
    return_type 'Hash'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def get_id(applocker_rules, name_to_id)
    applocker_rules.each do |key, value|
      # Check if the id is already defined.
      if name_to_id.key?(key)
        applocker_rules[key][id] = name_to_id[key]
      else
        # we need to generate the key
        id = "#{SecureRandom.hex(4)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(6)}"
        applocker_rules[key][id] = id
      end
    end
    applocker_rules
  end

  # you can define other helper methods in this code block as well
end
