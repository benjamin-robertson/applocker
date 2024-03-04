# frozen_string_literal: true

require 'open3'

# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:"applocker::verify_rules") do
  dispatch :verify_rules do
    param 'String', :applocker_xml_path
    return_type 'Boolean'
  end
  # the function below is called by puppet and and must match
  # the name of the puppet function above. You can set your
  # required parameters below and puppet will enforce these
  # so change x to suit your needs although only one parameter is required
  # as defined in the dispatch method.
  def verify_rules(applocker_xml_path)
    output, status = Open3.capture2("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe Test-AppLockerPolicy -XmlPolicy #{applocker_xml_path} -path C:\\windows\\notepad.exe")

    if status == 0
      true
    else
      false
    end
  end

  # you can define other helper methods in this code block as well
end
