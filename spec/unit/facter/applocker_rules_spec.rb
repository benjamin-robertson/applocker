# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/applocker_rules'

describe :applocker_rules, type: :fact do
  subject(:fact) { Facter.fact(:applocker_rules) }

  before :each do
    # perform any action that should be run before every test
    Facter.clear
    # allow(Facter::Util::Resolution).to receive(:exec).with('C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -command Get-ApplockerPolicy -Effective -xml').and_return('<AppLockerPolicy Version="1" />')
    powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    command = 'Get-ApplockerPolicy -Effective -xml'

    allow(Facter::Core::Execution).to receive(:execute).and_return('<AppLockerPolicy Version="1" />')
    # allow(Open3).to receive(:capture2).with(%(#{powershell} -command "#{command}")).and_return('<AppLockerPolicy Version="1" />')
    # allow(Open3).to receive(:capture2).and_return('<AppLockerPolicy Version="1" />') 
  end

  it 'returns a value' do
    # allow(Open3).to receive(:capture2).and_return('<AppLockerPolicy Version="1" />')
    expect(fact.value).to eq('<AppLockerPolicy Version="1" />')
    # expect(fact.value).to eq(nil)
  end
end
