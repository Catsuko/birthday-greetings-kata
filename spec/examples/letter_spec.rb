require 'spec_helper'

RSpec.describe Letter do
  describe 'filling out a letter' do
    let(:template) { 'Hello, {name}' }
    let(:name) { 'Lewis' }
    let(:letter) { Letter.new(template) }
    subject { letter.fill(name: name).to_s }

    it { is_expected.to include name }

    context 'when letter already has details' do
      let(:letter) { Letter.new(template, name: 'Shannon') }

      it 'overrides previously filled out detail' do
        is_expected.to include name
      end
    end
  end

  # What are the responsibilities of a person?
  # What are the responsibilities of an delivery medium?
  # Does a design like this work with the idea of a composite person class?
  describe 'sending a letter' do
    let(:person) { spy('Person') }
    let(:medium) { spy('Email') }
    subject { letter.send_to(person, via: medium) }
  end
end