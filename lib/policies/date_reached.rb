module Policies
  class DateReached
    def initialize(current, key:)
      @current = current
      @key = key
    end

    def evaluate?(details)
      @current.call.to_date == details.fetch(@key).to_date unless details[@key].nil?
    end
  end
end
