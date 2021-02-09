module People
  class FromHash
    STRING_FORMAT = "<Person %s>"

    def initialize(details = {})
      @details = details
    end

    def fill_out
      yield self, @details
    end

    def to_s
      STRING_FORMAT % @details
    end
  end
end
