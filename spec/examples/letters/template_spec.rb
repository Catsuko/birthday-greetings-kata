require 'spec_helper'

RSpec.describe Letters::Template do
  describe 'filling out a letter' do
    let(:template) { 'Hello, {name}' }
    let(:name) { 'Lewis' }
    let(:letter) { described_class.new(template) }
    subject { letter.fill(name: name).to_s }

    it { is_expected.to include name }

    context 'when letter already has details' do
      let(:letter) { described_class.new(template, name: 'Shannon') }

      it 'overrides previously filled out detail' do
        is_expected.to include name
      end
    end
  end

  describe 'sending a letter' do
    let(:person) { spy('Person') }
    let(:medium) { spy('Email') }
    let(:letter) { described_class.new('Hello friend') }
    subject { letter.send_to(person, via: medium) }

    it 'deliver the message to the person' do
      subject
      expect(medium).to have_received(:deliver).with(letter.to_s, to: person)
    end
  end
end
