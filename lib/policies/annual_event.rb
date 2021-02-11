module Policies
  class AnnualEvent
    def initialize(current, key:)
      @current = current
      @key = key
    end

    def evaluate?(details)
      same_date_and_month?(details.fetch(@key)) unless details[@key].nil?
    end

  private

    def same_date_and_month?(date)
      current_date.day == date.day && current_date.month == date.month
    end

    def current_date
      @current.call.to_date
    end
  end
end
