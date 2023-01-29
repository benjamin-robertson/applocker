# frozen_string_literal: true

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::sort_hash") do
  dispatch :sort_hash do
    param 'Hash', :hash_content
    return_type 'Hash'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def sort_hash(hash_content)
    hash_content.sort
  end

  # you can define other helper methods in this code block as well
end
