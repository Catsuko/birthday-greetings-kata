module Policies
  class Matched
    def initialize(criteria = {})
      @criteria = criteria
    end

    def evaluate?(details)
      @criteria.all? do |key, pattern|
        details.fetch(key).to_s.match?(pattern)
      end
    end
  end
end
