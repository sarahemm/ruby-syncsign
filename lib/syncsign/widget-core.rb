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
