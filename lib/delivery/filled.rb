module Delivery
  class Filled
    def initialize(delivery_method)
      @delivery_method = delivery_method
    end

    def deliver(message, to:)
      to.fill_out(@delivery_method).deliver(message, to: to)
    end
  end
end
