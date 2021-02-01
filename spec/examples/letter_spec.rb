require 'spec_helper'

RSpec.describe Letter do
  describe 'filling out a letter' do
    let(:template) { 'Hello, {name}' }
    let(:name) { 'Lewis' }
    subject { Letter.new(template).fill(name: name).to_s }

    it { is_expected.to include name }
  end
end