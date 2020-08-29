require 'json'

module SyncSign
  ##
  # Object that represents a template that can be rendered onto a display.
  # Contains +Widget+s which define the UI elements on the +Template+.
  class Template
    attr_accessor :bgcolour, :pollrate
    attr_reader :items

    ##
    # Initialize a new template and optionally add items to it.
    # @param bgcolour [Symbol] Background colour, one of :black, :white, or :red.
    # @param items [Array] List of Widgets to add to the template.
    # @param pollrate [Integer] How often (in ms) the node should poll the hub
    #   for new information.
    # @param enable_buttons [Boolean] Whether to enable the button labels at
    #   the bottom of the screen.
    def initialize(bgcolour: :white, items: [], pollrate: 10000, enable_buttons: false)
      @bgcolour = bgcolour
      @pollrate = pollrate
      @enable_buttons = enable_buttons
      
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
    # @param partial [Boolean] Whether to omit the background, which leaves
    # any information already on-screen in place.
    def to_s(partial: false)
      background = {
        bgColor: @bgcolour.to_s.upcase,
        enableButtonZone: @enable_buttons
      }
      items = @items.collect { |item| item.to_a }
      options = {'pollRate': @pollrate}
      tmpl = {
        layout: {
          background: background,
          items: items,
          options: options
        }
      }
      tmpl[:layout].delete(:background) if partial
      tmpl.to_json
    end
  end
end
