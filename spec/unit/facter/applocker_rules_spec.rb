# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/applocker_rules'

describe :applocker_rules, type: :fact do
  subject(:fact) { Facter.fact(:applocker_rules) }

  before :each do
    # perform any action that should be run before every test
    Facter.clear
  end

  it 'returns a value' do
    expect(fact.value).to eq(nil)
  end
end
