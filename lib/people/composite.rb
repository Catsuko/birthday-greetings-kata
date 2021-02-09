require_relative '../extensions/composite'

module People
  class Composite
    include ::Extensions::Composite

    def initialize(people = [])
      @people = people
    end

    def each(&block)
      @people.each(&block)
    end
  end
end
