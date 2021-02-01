module People
  class Birthday
    def initialize(date)
      @date = date
    end

    def on?(date)
      date == @date
    end
  end
end
