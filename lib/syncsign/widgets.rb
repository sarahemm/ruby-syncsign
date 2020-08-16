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
        Widget::check_colours [colour, bgcolour]
        @colour = colour
        @bgcolour = bgcolour
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
    end

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
            'fillColor': @bgcolour.to_s.upcase,
            'fillPattern': @fillpattern.to_s.upcase,
            'strokeColor': @colour.to_s.upcase,
            'strokePattern': @strokepattern.to_s.upcase,
            'strokeThickness': @pen_width
          }
        }
      end
    end

    ##
    # A widget that draws a text box.
    class Textbox < Box
      attr_accessor :font, :size, :id, :align, :text

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
      # @param align [Symbol] Whether to align the text left, center, or right.
      # @param text [String] The text to draw in the box.
      # @param id [String] An ID value to attach to the text box.
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, font: nil, size: nil, id: nil, align: :left, text: nil)
        check_font(font: font, size: size)
        raise(AlignmentException, "Textbox: either y or height must be a multiple of 8") if y % 8 != 0 and height % 8 != 0
        raise(AlignmentException, "Textbox: width must be a multiple of 8") if width % 8 != 0
        @font = font.upcase
        @size = size
        @id = id
        @align = align
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
            'textColor': @colour.to_s.upcase,
            'textAlign': @align.to_s.upcase,
            'font': "#{@font}_#{@size.to_s}",
            'text': @text
          }
        }
      end

      # Check a font/size combination to make sure it's valid.
      # Will raise ArgumentError if the font, size, or combination isn't supported..
      # @param font [Symbol] A symbol to check, representing a font.
      # @param size [Integer] A font size to check.
      def check_font(font: nil, size: nil)
        available_sizes = {
          :ddin => [16, 24, 32, 48, 64, 128],
          :ddin_condensed => [16, 24, 32, 48, 64],
          :charriot => [10],
          :aprilsans => [10, 16, 24],
          :roboto_condensed => [24, 48],
          :roboto_slab => [24, 48],
          :yanone_kaffeesatz => [24, 44],
          :kaushan_script => [20, 32],
          :sriracha => [24],
          :dorsa => [32],
          :londrina_outline => [36],
          :bungee_shade => [36],
          :noto_serif => [16],
          :noto_sans => [24, 40]
        }

        if(!available_sizes.keys.include? font) then
          raise ArgumentError, "#{font} is not a valid font. Available fonts: #{available_sizes.keys}"
        end
        if(!available_sizes[font].include? size) then
          raise ArgumentError, "#{font} is not available in size #{size}. Available sizes for this font: #{available_sizes[font].join(", ")}"
        end
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

    ##
    # Check a set of colours to make sure they're all valid.
    # Will raise ArgumentError if any elements are not valid colours.
    # @param colours [Array] An array of symbols to check.
    def self.check_colours(colours)
      colours.each do |colour|
        next if [:white, :black, :red].include? colour
        raise ArgumentError, "Colour must be :white, :black, or :red."
      end
    end
    
    # Check a set of patterns to make sure they're all valid.
    # Will raise ArgumentError if any elements are not valid patterns.
    # @param patterns [Array] An array of symbols to check.
    def self.check_patterns(patterns)
      patterns.each do |pattern|
        next if [:solid, :interleave, :dash_tiny, :dash_medium, :dash_wide, :none].include? pattern
        raise ArgumentError, "Pattern must be :solid, :interleave, :dash_tiny, :dash_medium, :dash_wide, or :none."
      end
    end
  end
end
