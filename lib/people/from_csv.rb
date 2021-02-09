require 'csv'
require_relative './from_hash'
require_relative '../extensions/composite'

module People
  class FromCSV
    include ::Extensions::Composite

    def initialize(csv_path)
      @csv_path = csv_path
    end

    def each
      return to_enum(:each) unless block_given?

      CSV.read(@csv_path, headers: true).each do |row|
        yield FromHash.new(row.to_h.transform_keys(&:to_sym))
      end
    end
  end
end
