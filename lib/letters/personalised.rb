require 'delegate'

module Letters
  class Personalised < ::SimpleDelegator
    def send_to(person, via:)
      via.deliver(person.fill(self).to_s, to: person)
    end

    def fill(details)
      Personalised.new(super)
    end
  end
end
