require 'spec_helper'

RSpec.describe Letters::Template do
  describe 'sending a letter' do
    let(:person) { People::FromHash.new }
    let(:medium) { Delivery::Spy.new }
    let(:letter) { described_class.new('Hello friend') }
    subject { letter.send_to(person, via: medium) }

    it 'deliver the message to the person' do
      expect { subject }.to change { medium.delivered_to?(person) }.by(1)
    end
  end
end
