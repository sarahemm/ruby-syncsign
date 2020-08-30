module SyncSign
  class Widget
    ##
    # A widget that draws a line.
    class Line
      attr_accessor :x0, :y0, :x1, :y1, :bgcolour, :colour, :pattern

      ##
      # Initialize a new line widget.
      # @param x0 [Integer] horizontal position of the starting point of the line.
      # @param y0 [Integer] vertical position of the starting point of the line.
      # @param x1 [Integer] horizontal position of the ending point of the line.
      # @param y1 [Integer] vertical position of the ending point of the line.
      # @param colour [Symbol] The stroke colour used for the rectangle
      #   (either black, white, or red).
      # @param bgcolour [Symbol] The fill colour used for the rectangle
      #   (either black, white, or red).
      # @param pattern [Symbol] The linestyle to use when drawing the line, one of solid, interleave, dash_tiny, dash_mid, or dash_wide.
      def initialize(x0: nil, y0: nil, x1: nil, y1: nil, bgcolour: :white, colour: :black, pattern: :solid)
        Widget::check_colours [colour, bgcolour]
        Widget::check_patterns [pattern]
        @x0 = x0
        @y0 = y0
        @x1 = x1
        @y1 = y1
        @colour = colour
        @bgcolour = bgcolour
        @pattern = pattern
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'LINE',
          'data': {
            'block': {x0: @x0, y0: @y0, x1: @x1, y1: @y1},
            'backgroundColor': @bgcolour.to_s.upcase,
            'lineColor': @colour.to_s.upcase,
            'linePattern': @pattern.to_s.upcase
          }
        }
      end

      def ==(other)
        @x0 == other.x0             &&
        @y0 == other.y0             &&
        @x1 == other.x1             &&
        @y1 == other.y1             &&
        @bgcolour == other.bgcolour &&
        @colour == other.colour     &&
        @pattern == other.pattern
      end
    end
  end
end
