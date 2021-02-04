module People
  class FromHash
    def initialize(details = {})
      @details = details
    end

    def fill_out(media)
      media.fill(**@details)
    end

    def receive(letter, via:)
      letter.send_to(self, via: via)
    end
  end
end
