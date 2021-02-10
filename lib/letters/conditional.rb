module Letters
  class Conditional
    def initialize(letter, policy:)
      @letter = letter
      @policy = policy
    end

    def send_to(person, via:)
      person.fill_out do |recipient, details|
        @letter.send_to(recipient, via: via) if @policy.evaluate?(details)
      end
    end
  end
end
