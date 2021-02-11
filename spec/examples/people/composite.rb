require 'spec_helper'

RSpec.describe Core::CompositeDelegator do
  let(:individuals) do
    [
      People::FromHash(name: 'Burgundy'),
      People::FromHash(name: 'Aqua'),
      People::FromHash(name: 'Steve')
    ]
  end
  subject { described_class.new(individuals) }

  describe 'filling out details' do
    it 'each individual provides details' do
      expected_details = individuals.map { |person| person.fill_out { |details| [person, details] } }
      expect { |b| subject.fill_out(&b) }.to yield_successive_args(*expected_details)
    end
  end
end