# frozen_string_literal: true

Facter.add(:applocker_rules) do
  confine kernel: 'windows'
    setcode do
      powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
      command = 'Get-ApplockerPolicy -Effective -xml'
      value = Facter::Util::Resolution.exec(%(#{powershell} -command "#{command}))
    end
  end
end
