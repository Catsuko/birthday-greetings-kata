require 'spec_helper'

RSpec.describe Policies::AnnualEvent do
  let(:current) { Proc.new { DateTime.parse('11th May 2021') } }
  let(:key) { :birthday }
  subject do
    person.fill_out do |_p, details|
      described_class.new(current, key: key).evaluate?(details)
    end
  end

  context 'when the date is not present in the details' do
    let(:person) { People::FromHash.new(name: 'Lewis') }

    it { is_expected.to be_falsey }
  end

  context 'when the given date is on the same day and month' do
    let(:person) { People::FromHash.new(key => DateTime.parse('11th May 1990')) }

    it { is_expected.to be_truthy }
  end

  context 'when the given date is not on the same day' do
    let(:person) { People::FromHash.new(key => DateTime.parse('10th May 1990')) }

    it { is_expected.to be_falsey }
  end

  context 'when the given date is not on the same month' do
    let(:person) { People::FromHash.new(key => DateTime.parse('11th April 1990')) }

    it { is_expected.to be_falsey }
  end
end
