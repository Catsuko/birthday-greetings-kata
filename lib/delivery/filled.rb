module Delivery
  class Filled
    def initialize(delivery_method)
      @delivery_method = delivery_method
    end

    # How will a system like this work with composite person object?
    # Ideally:
    # Send letter to people via email
    #   each person provides their email and receives the message sent to that address
    def deliver(message, to:)
      to.fill(@delivery_method).deliver(message, to: to)
    end
  end
end
