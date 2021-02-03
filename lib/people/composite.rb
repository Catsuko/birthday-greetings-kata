module People
  class Composite
    def initialize(people = [])
      @people = people
    end

    def receive(letter, via:)
      @people.each { |person| person.receive(letter, via: via) }
    end

    def fill_out(media)
      @people.inject(media) { |media, person| person.fill_out(media ) }
    end
  end
end
