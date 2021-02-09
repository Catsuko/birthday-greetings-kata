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

    def delivered_message?(pattern)
      @messages.select { |message| message.match?(pattern) }.size
    end

    def delivered_to?(recipient)
      @recipients.count(recipient)
    end
  end
end
