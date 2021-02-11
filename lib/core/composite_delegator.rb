module Core
  class CompositeDelegator
    include Composite

    def initialize(parts)
      @parts = parts
    end

    def each(&block)
      @parts.each(&block)
    end
  end
end
