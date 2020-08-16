require 'json'

module SyncSign
  ##
  # Raised when UI elements are not properly aligned.
  # Several UI elements must be aligned to a multiple of 8 or corruption will
  # occur on the display.
  class AlignmentException < StandardError
  end

  ##
  # Widgets are UI elements that are placed onto a +Template+ for rendering.
  class Widget

    ##
    # An item that contains only x/y coordinates. This can't be used on its own, only its
    # superclasses can be added to templates.
    class Item
      # @return [Integer] horizontal position of the item.
      attr_accessor :x
      # @return [Integer] vertical position of the item.
      attr_accessor :y
      
      ##
      # Initialize a new Item widget.
      # @param x [Integer] The horizontal position of the item.
      # @param y [Integer] The vertical position of the item.
      def initialize(x: nil, y: nil)
        @x = x
        @y = y
      end
    end

    ##
    # A box that contains x/y coordinates, width and height, and colour information.
    # This can't be used on its own, only its superclasses can be added to templates.
    # You may be looking for +Rectangle+ if you want to draw rectangles.
    class Box < Item
      # @return [Integer] the width of the box.
      attr_accessor :width
      # @return [Integer] the height of the box.
      attr_accessor :height
      # @return [Symbol] the stroke or foreground colour of the box.
      attr_accessor :colour
      # @return [Symbol] the background colour of the box.
      attr_accessor :bgcolour

      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white)
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        @width = width
        @height = height
        super(x: x, y: y)
      end
    end

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
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, pen_width: 1)
        raise(AlignmentException, "Rect: x and width must both be a multiple of 8") if x % 8 != 0 or width % 8 != 0
        @pen_width = pen_width
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'RECTANGLE',
          'data': {
            'block': {x: @x, y: @y, w: @width, h: @height},
            'fillColor': @bgcolour,
            'strokeColor': @colour,
            'strokeThickness': @pen_width
          }
        }
      end
    end

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
        @x0 = x0
        @y0 = y0
        @x1 = x1
        @y1 = y1
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        @pattern = pattern.to_s.upcase
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'LINE',
          'data': {
            'block': {x0: @x0, y0: @y0, x1: @x1, y1: @y1},
            'backgroundColor': @bgcolour,
            'lineColor': @colour,
            'linePattern': @pattern
          }
        }
      end
    end

    ##
    # A widget that draws a circle.
    class Circle < Item
      attr_accessor :radius, :bgcolour, :colour, :pattern

      ##
      # Initialize a new circle widget.
      # @param x [Integer] horizontal position of the centre of the circle.
      # @param y [Integer] vertical position of the centre of the circle
      # @param radius [Integer] The radius of the circle in pixels.
      # @param colour [Symbol] The stroke colour used for the rectangle
      #   (either black, white, or red).
      # @param bgcolour [Symbol] The fill colour used for the rectangle
      #   (either black, white, or red).
      # @param fillpattern [Symbol] The fill pattern to use when filling the circle.
      # @param strokepattern [Symbol] The stroke pattern to use when drawing the circle.
      def initialize(x: nil, y: nil, radius: nil, bgcolour: :white, colour: :black, fillpattern: :hollow, strokepattern: :solid)
        @radius = radius
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        @fillpattern = fillpattern.to_s.upcase
        @strokepattern = strokepattern.to_s.upcase
        super(x: x, y:y)
      end
      
      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'CIRCLE',
          'data': {
            'center': {x: @x, y: @y},
            'fillColor': @bgcolour,
            'fillPattern': @fillpattern,
            'strokeColor': @colour,
            'strokePattern': @strokepattern
          }
        }
      end
    end

    ##
    # A widget that draws a text box.
    class Textbox < Box
      attr_accessor :font, :size, :bold, :id, :align, :text

      ##
      # Initialize a new text box widget.
      # @param x [Integer] horizontal position of the left side of the text box.
      # @param y [Integer] vertical position of the top of the text box.
      # @param width [Integer] how wide the text box should be.
      # @param height [Integer] how tall the text box should be.
      # @param colour [Symbol] The text colour used for the text.
      # @param bgcolour [Symbol] The background colour used for the text box.
      # @param font [Symbol] The font to use when drawing the text.
      # @param size [Integer] The point size to use when drawing the text.
      # @param bold [Boolean] Whether the text should be bold or not.
      # @param align [Symbol] Whether to align the text left, center, or right.
      # @param text [String] The text to draw in the box.
      # @param id [String] An ID value to attach to the text box.
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, font: nil, size: nil, bold: false, id: nil, align: :left, text: nil)
        raise(AlignmentException, "Textbox: either y or height must be a multiple of 8") if y % 8 != 0 and height % 8 != 0
        raies(AlignmentException, "Textbox: width must be a multiple of 8") if width % 8 != 0
        @font = font.upcase
        @size = size
        @bold = bold
        @id = id
        @align = align.to_s.upcase
        @text = text
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end

      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'TEXT',
          'data': {
            'block': {x: @x, y: @y, w: @width, h: @height},
            'textColor': @colour,
            'textAlign': @align,
            'font': "#{@font}_#{@size.to_s}",
            'text': @text
          }
        }
      end
    end

    ##
    # A widget that draws a QR code.
    class QRCode < Item
      # @return [Integer] scale of the QR code (how many pixels to use to
      #   represent each base pixel).
      attr_accessor :scale
      # @return [Integer] the version (which is actually size, in QR-speak)
      #   of this QR code.
      attr_accessor :version
      # @return [Symbol] the level of error checking code for this QR code,
      #   either :low, :medium, :quartile, or :high.
      attr_accessor :ecclevel
      # @return [String] the text to encode in this QR code.
      attr_accessor :text
      
      ##
      # Initialize a new QR code widget.
      # @param x [Integer] horizontal position of the left side of the QR code.
      # @param y [Integer] vertical position of the top of the QR code.
      # @param scale [Integer] scale of the QR code (how many pixels to use to
      #   represent each base pixel).
      # @param version [Integer] the version (which is actually size, in QR-speak)
      #   of this QR code. 
      # @param ecclevel [Symbol] the level of error checking code for this QR code,
      #   either :low, :medium, :quartile, or :high. 
      # @param text [String] the text to encode in this QR code.
      def initialize(x: nil, y: nil, scale: 4, version: 2, ecclevel: :medium, text: nil)
        @scale = scale
        @version = version
        @ecclevel = ecclevel
        @text = text

        super(x: x, y: y)
      end

      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        {
          'type': 'QRCODE',
          'data': {
            'scale': @scale,
            'eccLevel': @ecclevel.to_s.upcase,
            'version': @version,
            'position': {x: @x, y: @y},
            'text': @text
          }
        }
      end
    end
  end
end
