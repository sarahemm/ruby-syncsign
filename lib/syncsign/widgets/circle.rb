module SyncSign
  class Widget
    ##
    # A widget that draws a circle.
    class Circle < Item
      attr_accessor :radius, :bgcolour, :colour, :fillpattern, :strokepattern

      ##
      # Initialize a new circle widget.
      # @param x [Integer] horizontal position of the centre of the circle.
      # @param y [Integer] vertical position of the centre of the circle
      # @param radius [Integer] The radius of the circle in pixels.
      # @param colour [Symbol] The stroke colour used for the circle
      #   (either black, white, or red).
      # @param bgcolour [Symbol] The fill colour used for the circle
      #   (either black, white, or red).
      # @param fillpattern [Symbol] The fill pattern to use when filling the circle.
      # @param strokepattern [Symbol] The stroke pattern to use when drawing the circle.
      # @param pen_width [Integer] The thickness in pixels of the stroke.
      def initialize(x: nil, y: nil, radius: nil, bgcolour: :white, colour: :black, fillpattern: :none, strokepattern: :solid, pen_width: 1)
        Widget::check_colours [colour, bgcolour]
        Widget::check_patterns [fillpattern, strokepattern]
        @radius = radius
        @colour = colour
        @bgcolour = bgcolour
        @fillpattern = fillpattern
        @strokepattern = strokepattern
        @pen_width = pen_width
        super(x: x, y:y)
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'CIRCLE',
          'data': {
            'center': {x: @x, y: @y},
            'radius': @radius,
            'fillColor': @bgcolour.to_s.upcase,
            'fillPattern': @fillpattern.to_s.upcase,
            'strokeColor': @colour.to_s.upcase,
            'strokePattern': @strokepattern.to_s.upcase,
            'strokeThickness': @pen_width
          }
        }
      end

      def ==(other)
        @x == other.x                         &&
        @y == other.x                         &&
        @width == other.width                 &&
        @height == other.height               &&
        @radius == other.radius               &&
        @bgcolour == other.bgcolour           &&
        @colour == other.colour               &&
        @fillpattern == other.fillpattern     &&
        @strokepattern == other.strokepattern &&
        @pen_width == other.pen_width
      end
    end
  end
end
