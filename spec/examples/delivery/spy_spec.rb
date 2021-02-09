require 'spec_helper'

RSpec.describe Delivery::Spy do
  describe 'sending via the spy' do
    subject { described_class.new }
    let(:message) { 'Hello' }
    let(:recipient) { People::FromHash.new }

    it 'messages are captured' do
      expect { subject.deliver(message, to: recipient) }.to change { 
        subject.delivered_message?(/#{message}/) 
      }.by(1)
    end

    it 'recipients are captured' do
      expect { subject.deliver(message, to: recipient) }.to change {
        subject.delivered_to?(recipient)
      }.by(1)
    end
  end
end