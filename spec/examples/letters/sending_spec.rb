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
      Core::CompositeDelegator.new([
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

  describe 'when sending multiple letters' do
    let(:person) { People::FromHash.new(name: 'Alphonse') }
    let(:messages) { %w[Hello What Goodbye] }
    let(:letter) { Core::CompositeDelegator.new(messages.map { |message| Letters::Template.new(message) }) }

    it 'each letter is delivered' do
      subject
      messages.each do |message|
        expect(delivery_method.delivered_message?(/#{message}/)).to be_positive
      end
    end
  end

  describe 'when sending letters to people with certain details' do
    let(:lisa) { People::FromHash.new(name: 'Lisa') }
    let(:bart) { People::FromHash.new(name: 'Bart') }
    let(:person) { Core::CompositeDelegator.new([lisa, bart]) }
    let(:letter) do
      Letters::Conditional.new(
        Letters::Template.new('Hey Bart'),
        policy: Policies::Matched.new(name: /\Ab/i)
      )
    end

    it 'letter is delivered to person with name starting with B' do
      expect { subject }.to change { delivery_method.delivered_to?(bart) }.by(1)
    end

    it 'letter is not delivered to person with name starting with L' do
      expect { subject }.not_to change { delivery_method.delivered_to?(lisa) }
    end
  end
end
