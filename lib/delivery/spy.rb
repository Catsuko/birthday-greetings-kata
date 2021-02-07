module Delivery
  class Spy
    def initialize
      @recipients = []
      @messages = []
    end

    def deliver(message, to:)
      tap do
        @recipients << to
        @messages << message
      end
    end

    def delivered_message?(message)
      @messages.count(message)
    end

    def delivered_matching_message?(pattern)
      @messages.any? { |message| message.match?(pattern) }
    end

    def delivered_to?(recipient)
      @recipients.count(recipient)
    end
  end
end
