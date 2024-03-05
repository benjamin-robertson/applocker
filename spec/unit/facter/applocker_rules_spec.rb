# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/applocker_rules'

describe :applocker_rules, type: :fact do
  subject(:fact) { Facter.fact(:applocker_rules) }

  before :each do
    # perform any action that should be run before every test
    Facter.clear
    powershell = 'C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe'
    command = 'Get-ApplockerPolicy -Effective -xml'

    allow(Facter::Core::Execution).to receive(:execute).and_return('<AppLock1erPolicy Version="1" />')
  end

  it 'returns a value' do
    expect(fact.value).to eq('<AppLockerPolicy Version="1" />')
  end
end
