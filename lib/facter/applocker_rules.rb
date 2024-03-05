# frozen_string_literal: true

require 'open3'

Facter.add(:applocker_rules) do
  confine kernel: 'windows'
  setcode do
    powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    command = 'Get-ApplockerPolicy -Effective -xml'
    Facter::Core::Execution.execute(%(#{powershell} -command "#{command}"))
  end
end
