module People
  class FromHash
    STRING_FORMAT = "<Person %s>"

    def initialize(details = {})
      @details = details
    end

    def fill_out(media)
      media.fill(**@details)
    end

    def receive(letter, via:)
      letter.send_to(self, via: via)
    end

    def to_s
      STRING_FORMAT % @details
    end
  end
end
