module SyncSign
  class Widget
    ##
    # A widget that draws a text box.
    class Textbox < Box
      attr_accessor :font, :size, :id, :align, :text, :linespacing

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
      # @param linespacing [Integer] How much space to leave between each line.
      # @param text [String] The text to draw in the box.
      # @param id [String] An ID value to attach to the text box.
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, font: nil, size: nil, id: nil, align: :left, linespacing: 2, text: nil)
        check_font(font: font, size: size)
        raise(AlignmentException, "Textbox: either y or height must be a multiple of 8") if y % 8 != 0 and height % 8 != 0
        raise(AlignmentException, "Textbox: width must be a multiple of 8") if width % 8 != 0
        @font = font.upcase
        @size = size
        @id = id
        @align = align
        @linespacing = linespacing
        @text = text
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end

      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        font_string = "#{@font}_#{@size.to_s}"
        # this one font has to be specified in a different way
        font_string += "_B" if @font.to_s.upcase == "YANONE_KAFFEESATZ"
        {
          'type': 'TEXT',
          'data': {
            'block': {x: @x, y: @y, w: @width, h: @height},
            'textColor': @colour.to_s.upcase,
            'textAlign': @align.to_s.upcase,
            'font': font_string,
            'lineSpace': @linespacing,
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

      def ==(other)
        @x == other.x                           &&
        @y == other.y                           &&
        @width == other.width                   &&
        @height == other.height                 &&
        @colour == other.colour                 &&
        @bgcolour == other.bgcolour             &&
        @font == other.font                     &&
        @size == other.size                     &&
        @id == other.id                         &&
        @linespacing == other.linespacing       &&
        @align == other.align                   &&
        @text == other.text
      end
    end
  end
end
