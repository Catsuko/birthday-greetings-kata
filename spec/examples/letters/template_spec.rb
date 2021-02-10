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

    context 'when letter contains placeholders' do
      let(:letter) { described_class.new('Hello {name}') }
      let(:name) { 'Lewis' }
      let(:person) { People::FromHash.new(name: name) }

      it 'fill placeholders using details from the person' do
        expect { subject }.to change { medium.delivered_message?(/#{name}/) }.by(1)
      end
    end
  end
end
