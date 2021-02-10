require 'spec_helper'

RSpec.describe 'sending letters' do
  let(:delivery_method) { Delivery::Spy.new }
  subject { letter.send_to(person, via: delivery_method) }

  context 'when letter is can be personlised' do
    let(:name) { 'Lewis' }
    let(:person) { People::FromHash.new(name: name) }
    let(:letter) { Letters::Template.new('Hello {name}!') }

    it 'person receives the message' do
      expect { subject }.to change {
        delivery_method.delivered_to?(person)
      }.by(1)
    end

    it 'delivered message contains recipient details' do
      expect { subject }.to change {
        delivery_method.delivered_message?(/#{name}/)
      }.by(1)
    end
  end

  describe 'when there are multiple recipients' do
    let(:person) do
      People::Composite.new([
        People::FromHash.new(name: 'Steve'),
        People::FromHash.new(name: 'Sarah'),
        People::FromHash.new(name: 'Terry')
      ])
    end
    let(:letter) { Letters::Template.new('Did you know that MegaMart is having a 10% off sale??!') }

    it 'each person receives a message' do
      subject
      expect(person.map { |p| delivery_method.delivered_to?(p) }).to all be_positive
    end
  end
end