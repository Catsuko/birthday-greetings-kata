module Policies
  class LeapYearInclusiveEvent
    def initialize(current, key:)
      @current = current
      @key = key
    end

    def evaluate?(details)
      details.key?(@key) && matching_annual_date?(leap_year_inclusive_date(details[@key]))
    end

  private

    def leap_year_inclusive_date(date)
      if current_date.leap? || date.month != 2 || date.day != 29
        date
      else
        Date.new(date.year, date.month, date.day - 1)
      end
    end

    def current_date
      @current.call
    end

    def matching_annual_date?(other_date)
      current_date.month == other_date.month && current_date.day == other_date.day
    end
  end
end