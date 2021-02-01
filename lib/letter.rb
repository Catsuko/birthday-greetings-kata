class Letter
  def initialize(template, details: {})
    @template = template
    @details = details
  end

  def fill(details)
    Letter.new(@template, details: @details.merge(details))
  end

  def to_s
    @details.reduce(@template) do |str, (k, v)|
      str.gsub(/{#{k}}/, v)
    end
  end
end
