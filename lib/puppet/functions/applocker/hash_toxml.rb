# frozen_string_literal: true

require 'xmlsimple'

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::hash_toxml") do
  dispatch :hash_toxml do
    param 'Hash', :hash_val
    return_type 'String'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def hash_toxml(hash_val)
    XmlSimple.xml_out(hash_val)
  end

  # you can define other helper methods in this code block as well
end
