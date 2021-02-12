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
      current_date == Date.new(current_date.year, date.month, date.day)
    end

    def current_date
      @current.call
    end
  end
end
