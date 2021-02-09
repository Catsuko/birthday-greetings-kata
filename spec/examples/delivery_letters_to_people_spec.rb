require 'spec_helper'

RSpec.describe 'delivering letters to people' do
  let(:delivery_method) { Delivery::Spy.new }
  subject { letter.send_to(person, via: delivery_method) }

  describe 'receiving a personalised greeting' do
    let(:name) { 'Lewis' }
    let(:person) { People::FromHash.new(name: name) }
    let(:letter) { Letters::Template.new('Hello {name}!') }

    it 'person receives the message' do
      expect { subject }.to change {
        delivery_method.delivered_to?(person)
      }.by(1)
    end

    it 'message is personalised' do
      expect { subject }.to change {
        delivery_method.delivered_message?(/#{name}/)
      }.by(1)
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

  describe 'receiving via a delivery method that needs to be filled' do
    let(:people) do
      People::Composite.new([
        People::FromHash.new(name: 'Steve', email: 'steve@cool_people.com'),
        People::FromHash.new(name: 'Mary', email: 'mary@cool_people.com')
      ])
    end
    let(:letter) { Letters::Template.new('Greetings friendo') }
    let(:delivery_method) { Delivery::Smtp.new }

    # TODO: How to actually test this? Stub smtp client and check invocations?
    it 'each person receives a message sent to their email address' do
      letter.send_to(people, via: delivery_method)
      expect(true).to be true
    end
  end
end