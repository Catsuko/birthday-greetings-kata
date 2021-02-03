require 'spec_helper'

RSpec.describe Letters::Personalised do
  let(:letter) { Letters::Template.new('hello {name}') }

  describe 'formatting as string' do
    subject { described_class.new(letter).to_s }

    it 'delegates to decorated letter' do
      expect(subject).to eq letter.to_s
    end
  end

  describe 'filling out details' do
    let(:name) { 'Lewis' }
    subject { described_class.new(letter).fill(name: name) }

    it 'decorated letter is filled out' do
      expect(subject.to_s).to eq letter.fill(name: name).to_s
    end

    it 'result is decorated' do
      expect(subject.class).to eq described_class
    end
  end

  describe 'sending a personalised letter' do
    let(:name) { 'Lewis' }
    let(:person) { People::FromHash.new(name: name) }
    let(:medium) { spy('Email') }
    let(:personal_letter) { described_class.new(letter) }
    subject { personal_letter.send_to(person, via: medium) }

    it 'delivered message is personalised' do
      subject
      expect(medium).to have_received(:deliver).with(person.fill(personal_letter).to_s, to: person)
    end
  end
end
