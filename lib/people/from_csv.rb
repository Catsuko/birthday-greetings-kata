require 'csv'
require_relative './from_hash'
require_relative '../core/composite'

module People
  class FromCSV
    include ::Core::Composite

    def initialize(csv_path, converters: %i[numeric date])
      @csv_path = csv_path
      @converters = converters
    end

    def each
      return to_enum(:each) unless block_given?

      CSV.read(@csv_path, headers: true, converters: @converters).each do |row|
        yield FromHash.new(row.to_h.transform_keys(&:to_sym))
      end
    end
  end
end
