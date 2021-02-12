module Policies
  class DateReached
    def initialize(current, key:)
      @current = current
      @key = key
    end

    def evaluate?(details)
      @current.call == details.fetch(@key).to_date unless details[@key].nil?
    end
  end
end
