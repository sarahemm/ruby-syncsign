require 'json'

module SyncSign
  class Template
    attr_accessor :background, :items, :pollrate

    def initialize(background: {}, items: [], pollrate: 10000)
      @background = background
      @items = items
      @pollrate = pollrate
    end

    def to_s
      options = {'pollRate': @pollrate}
      {
        layout: {
          background: @background,
          items: @items,
          options: options
        }
      }.to_json
    end
  end
end
