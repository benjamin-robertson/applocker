# frozen_string_literal: true

require 'xmlsimple'

# XML to hash
Puppet::Functions.create_function(:"applocker::xml_tohash") do
  # @param xml_content XML to convert to hash
  # @return [Hash] Hash converted from XML
  dispatch :xml_tohash do
    param 'String', :xml_content
    return_type 'Hash'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def xml_tohash(xml_content)
    XmlSimple.xml_in(xml_content)
  end

  # you can define other helper methods in this code block as well
end
