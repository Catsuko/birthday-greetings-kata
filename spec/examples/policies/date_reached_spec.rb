require 'spec_helper'

RSpec.describe Policies::DateReached do
  let(:target) { Proc.new { Date.today } }
  subject do
    person.fill_out do |_p, details|
      described_class.new(target, key: key).evaluate?(details)
    end
  end

  context 'when the date is not present in the details' do
    let(:person) { People::FromHash.new(name: 'Lewis') }
    let(:key) { :festivus }

    it { is_expected.to be_falsey }
  end

  context 'when the date matches the target' do
    let(:key) { :favourite_day }
    let(:person) { People::FromHash.new(key => DateTime.now) }

    it { is_expected.to be_truthy }
  end

  context 'when the date does not match the target' do
    let(:key) { :lucky_day }
    let(:person) { People::FromHash.new(key => DateTime.parse('3rd Feb 2001')) }

    it { is_expected.to be_falsey }
  end
end