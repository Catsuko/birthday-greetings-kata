require 'csv'
require_relative './from_hash'

module People
  class FromCSV
    include Enumerable

    def initialize(csv_path)
      @csv_path = csv_path
    end

    def fill_out(media)
      each { |person| person.fill_out(media) }
    end

    def receive(letter, via:)
      each { |person| person.receive(letter, via: via) }
    end

    def each
      return to_enum(:each) unless block_given?

      CSV.read(@csv_path, headers: true).each do |row|
        yield FromHash.new(row.to_h.transform_keys(&:to_sym))
      end
    end
  end
end
