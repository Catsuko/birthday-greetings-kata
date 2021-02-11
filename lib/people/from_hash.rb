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

    def ==(other)
      other.is_a?(self.class) && other.fill_out { |_p, details| details == @details }
    end

    def eql?(other)
      other == self
    end
  end
end
