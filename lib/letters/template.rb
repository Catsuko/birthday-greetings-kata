module Letters
  class Template
    def initialize(template)
      @template = template
    end

    def send_to(person, via:)
      person.fill_out do |recipient, details|
        via.deliver(format(details), to: recipient)
      end
    end

  private

    def format(details)
      details.reduce(@template) do |message, (k, v)|
        message.gsub(/{#{k}}/, v)
      end
    end
  end
end
