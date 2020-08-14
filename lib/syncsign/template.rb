require 'json'

module SyncSign
  class Template
    attr_accessor :background, :pollrate
    attr_reader :items

    def initialize(background: {}, items: [], pollrate: 10000)
      @background = background
      @pollrate = pollrate
      
      @items = []
      items.each do |item|
        self.+(item)
      end
    end
    
    def +(to_add)
      # TODO: make sure we only add widgets
      @items.push to_add
    end
    
    def to_s
      options = {'pollRate': @pollrate}
      items = @items.collect { |item| item.to_a }
      {
        layout: {
          background: @background,
          items: items,
          options: options
        }
      }.to_json
    end
  end
end
