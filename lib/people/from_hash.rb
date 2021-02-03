module People
  class FromHash
    def initialize(details = {})
      @details = details
    end

    def fill(media)
      media.fill(**@details)
    end
  end
end