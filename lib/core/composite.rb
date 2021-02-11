module Core
  module Composite
    include Enumerable

    def method_missing(method_name, *args, &block)
      each { |unit| unit.send(method_name, *args, &block) }
    end

    def each
      raise 'Composite objects must implement the each method.'
    end
  end
end