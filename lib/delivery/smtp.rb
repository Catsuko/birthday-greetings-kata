module Delivery
  class Smtp
    def deliver(message, to:)
      to.fill_out do |details|
        raise 'An email address is required' unless details.key?(:email)

        puts "TODO: Send #{message} to #{details.fetch(:email)} by SMTP"
      end
    end
  end
end
