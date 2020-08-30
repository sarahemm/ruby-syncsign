module SyncSign
  class Widget
    ##
    # A widget that draws a rectangle.
    class Rectangle < Box
      attr_accessor :pen_width
      
      ##
      # Initialize a new rectangle widget.
      # @param x [Integer] horizontal position of the left side of the rectangle.
      # @param y [Integer] vertical position of the top of the rectangle.
      # @param width [Integer] how wide the rectangle should be.
      # @param height [Integer] how tall the rectangle should be.
      # @param colour [Symbol] The stroke colour used for the rectangle
      #   (either black, white, or red).
      # @param bgcolour [Symbol] The fill colour used for the rectangle
      #   (either black, white, or red).
      # @param pen_width [Integer] The width in pixels of the stroke.
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, pen_width: 1, fillpattern: :none, strokepattern: :solid)
        Widget::check_patterns [fillpattern, strokepattern]
        raise(AlignmentException, "Rect: x and width must both be a multiple of 8") if x % 8 != 0 or width % 8 != 0
        @pen_width = pen_width
        @fillpattern = fillpattern
        @strokepattern = strokepattern
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'RECTANGLE',
          'data': {
            'block': {x: @x, y: @y, w: @width, h: @height},
            'fillColor': @bgcolour.to_s.upcase,
            'fillPattern': @fillpattern.to_s.upcase,
            'strokeColor': @colour.to_s.upcase,
            'strokePattern': @strokepattern.to_s.upcase,
            'strokeThickness': @pen_width
          }
        }
      end
    end
  end
end
