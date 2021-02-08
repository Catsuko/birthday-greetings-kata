module Delivery
  class Smtp
    def initialize(to_address: nil)
      @to_address = to_address
    end

    def deliver(message, to:)
      self
    end

    def fill(details)
      Smtp.new(to_address: details.fetch(:email, nil))
    end
  end
end
