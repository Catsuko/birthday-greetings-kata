module Delivery
  class ConsoleLog
    def initialize(format="Sending to %s:\n'%s'")
      @format = format
    end

    def deliver(message, to:)
      printf(@format, to.to_s, message)
    end
  end
end
