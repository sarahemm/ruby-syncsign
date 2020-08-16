require 'json'

module SyncSign
  ##
  # Object that represents a template that can be rendered onto a display.
  # Contains +Widget+s which define the UI elements on the +Template+.
  class Template
    attr_accessor :background, :pollrate
    attr_reader :items

    ##
    # Initialize a new template and optionally add items to it.
    # @param background [Hash] TODO
    # @param items [Array] List of Widgets to add to the template.
    # @param pollrate [Integer] How often (in ms) the node should poll the hub
    #   for new information.
    def initialize(background: {}, items: [], pollrate: 10000)
      @background = background
      @pollrate = pollrate
      
      @items = []
      items.each do |item|
        self.+(item)
      end
    end
    
    ##
    # Add a new widget to the template.
    # @param to_add [Widget] Widget to add to the template.
    def +(to_add)
      # TODO: make sure we only add widgets
      @items.push to_add
    end
    
    ##
    # Output this template as JSON in the format that the SyncSign service understands.
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
