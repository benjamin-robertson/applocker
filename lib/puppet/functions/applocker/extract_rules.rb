# frozen_string_literal: true

# Extract applocker rules
Puppet::Functions.create_function(:"applocker::extract_rules") do
  # @param rules Applocker rules to extract
  # @return [Hash] Hash of all applocker rules in policy along with the rule hash.
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
    # Create hash strucutures
    rule_status = {
      'Appx'   => '',
      'Dll'    => '',
      'Exe'    => '',
      'Msi'    => '',
      'Script' => ''
    }
    rule_hash = {
      'Appx'   => [],
      'Dll'    => [],
      'Exe'    => [],
      'Msi'    => [],
      'Script' => []
    }
    name_to_id = {}

    # check rules exist
    unless rules['RuleCollection']
      return {}
    end

    # Loop through Rules and populate hash values
    rules['RuleCollection'].each do |array|
      rule_status[array['Type']] = array['EnforcementMode']
      array['FilePathRule']&.each do |value|
        hash_tmp = { 'name' => value['Name'], 'id' => value['Id'] }
        rule_hash[array['Type']].push(hash_tmp)
        name_to_id[value['Name']] = value['Id']
      end
      array['FilePublisherRule']&.each do |value|
        hash_tmp = { 'name' => value['Name'], 'id' => value['Id'] }
        rule_hash[array['Type']].push(hash_tmp)
        name_to_id[value['Name']] = value['Id']
      end
      array['FileHashRule']&.each do |value|
        hash_tmp = { 'name' => value['Name'], 'id' => value['Id'] }
        rule_hash[array['Type']].push(hash_tmp)
        name_to_id[value['Name']] = value['Id']
      end
    end
    return_hash = { 'rule_status' => rule_status, 'rule_hash' => rule_hash, 'name_to_id' => name_to_id }
    return_hash
  end

  # you can define other helper methods in this code block as well
end
