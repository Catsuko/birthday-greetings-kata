module Delivery
  class Smtp
    def deliver(message, to:)
      to.fill_out do |details|
        raise 'An email address is required' unless details.key?(:email)

        puts "Send #{message} to #{details}"
      end
    end
  end
end
