require 'delegate'

module Letters
  class Personalised < ::SimpleDelegator
    def send_to(person, via:)
      via.deliver(person.fill_out(self).to_s, to: person)
    end
  end
end
