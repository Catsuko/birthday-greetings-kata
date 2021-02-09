module Delivery
  class Smtp
    def deliver(message, to:)
      to.fill_out do |details|
        puts "Send #{message} to #{details}"
      end
    end
  end
end