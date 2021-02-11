module Policies
  class DateReached
    def initialize(target, key:)
      @target = target
      @key = key
    end

    def evaluate?(details)
      @target.call == details.fetch(@key).to_date unless details[@key].nil?
    end
  end
end
