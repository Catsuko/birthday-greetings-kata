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

  describe 'when sending letters to people on their birthdays' do
    let(:current_date) { Date.parse('11th May 2021') }
    let(:lucky) { People::FromHash.new(name: 'Lucky', date_of_birth: Date.parse('11th May 1990')) }
    let(:bones) { People::FromHash.new(name: 'Bones', date_of_birth: Date.parse('4th April 1989')) }
    let(:person) { Core::CompositeDelegator.new([lucky, bones]) }
    let(:letter) do
      Letters::Conditional.new(
        Letters::Template.new('Happy Birthday {name}'),
        policy: Policies::AnnualEvent.new(Proc.new { current_date }, key: :date_of_birth)
      )
    end

    it 'letter is delivered to the birthday dog' do
      expect { subject }.to change { delivery_method.delivered_to?(lucky) }.by(1)
    end

    it 'letter is not delivered to the other dog' do
      expect { subject }.not_to change { delivery_method.delivered_to?(bones) }
    end

    context 'when from csv' do
      let(:current_date) { Date.parse('8th October 2021') }
      let(:csv_path) { 'spec\support\data\birthdays.csv' }
      let(:person) { People::FromCSV.new(csv_path) }

      it 'letter is delivered to person whose birthday it is' do
        expect { subject }.to change { delivery_method.delivered_to?(person.first) }.by(1)
      end

      it 'letter is not delivered to anyone else' do
        subject
        person.drop(1).each do |individual|
          expect(delivery_method.delivered_to?(individual)).to be_zero
        end
      end
    end
  end
end
