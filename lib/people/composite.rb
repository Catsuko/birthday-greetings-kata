module People
  class Composite
    include Enumerable

    def initialize(people = [])
      @people = people
    end

    def receive(letter, via:)
      @people.each { |person| person.receive(letter, via: via) }
    end

    def fill_out(media)
      @people.inject(media) { |media, person| person.fill_out(media ) }
    end

    def each(&block)
      @people.each(&block)
    end
  end
end
