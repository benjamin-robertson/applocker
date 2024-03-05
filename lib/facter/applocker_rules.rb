# frozen_string_literal: true

require 'open3'

Facter.add(:applocker_rules) do
  confine kernel: 'windows'
  setcode do
    powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    command = 'Get-ApplockerPolicy -Effective -xml'
    # Facter::Util::Resolution.exec(%(#{powershell} -command "#{command}))
    Facter::Core::Execution.execute(%(#{powershell} -command "#{command}"))
    # output, status = Open3.capture2(%(#{powershell} -command "#{command}"))
    # output
  end
end
