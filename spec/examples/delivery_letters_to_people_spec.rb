require 'spec_helper'

RSpec.describe 'delivering letters to people' do
  let(:delivery_method) { Delivery::Spy.new }
  subject { person.receive(letter, via: delivery_method) }

  describe 'receiving a personalised greeting' do
    let(:name) { 'Lewis' }
    let(:person) { People::FromHash.new(name: name) }
    let(:letter) { Letters::Personalised.new(Letters::Template.new('Hello {name}!')) }

    it 'person receives the message' do
      expect { subject }.to change {
        delivery_method.delivered_to?(person)
      }.by(1)
    end

    it 'message is personalised' do
      expect { subject }.to change {
        delivery_method.delivered_matching_message?(/#{name}/)
      }.to(true)
    end
  end

  describe 'receiving mass marketed spam' do
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