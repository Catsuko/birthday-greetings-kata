require 'date'
require 'spec_helper'

RSpec.describe 'birthdays' do
  context 'when the birthday is today' do
    subject { People::Birthday.new(Date.today) }

    it { expect(subject.on?(Date.today)).to be true }
  end

  context 'when the birthday was yesterday' do
    subject { People::Birthday.new(Date.today - 1) }

    it { expect(subject.on?(Date.today)).to eq false }
  end
end
