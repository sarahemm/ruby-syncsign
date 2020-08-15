require 'json'

class AlignmentException < StandardError
end

module SyncSign
  class Widget
    class Item
      attr_accessor :x, :y
      
      def initialize(x: nil, y: nil)
        @x = x
        @y = y
      end
    end

    class Box < Item
      attr_accessor :width, :height

      def initialize(x: nil, y: nil, width: nil, height: nil)
        @width = width
        @height = height
        super(x: x, y: y)
      end
    end

    class ColourBox < Box
      attr_accessor :colour, :bgcolour

      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white)
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        super(x: x, y: y, width: width, height: height)
      end
    end

    class Rectangle < ColourBox
      attr_accessor :pen_width

      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, pen_width: 1)
        raise(AlignmentException, "Rect: x and width must both be a multiple of 8") if x % 8 != 0 or width % 8 != 0
        @pen_width = pen_width
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end
      
      def to_a
        out = {}
        out['type'] = 'RECTANGLE'
        out['data'] = {}
        out['data']['block'] = {x: @x, y: @y, w: @width, h: @height}
        out['data']['fillColor'] = @bgcolour
        out['data']['strokeColor'] = @colour
        out['data']['strokeThickness'] = @pen_width
        out
      end
    end

    class Textbox < ColourBox
      attr_accessor :font, :size, :bold, :id, :align, :text

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

      def to_a
        out = {}
        out['type'] = 'TEXT'
        out['data'] = {}
        out['data']['font'] = "#{@font}_#{@size.to_s}"
        out['data']['block'] = {x: @x, y: @y, w: @width, h: @height}
        out['data']['textColor'] = @colour
        out['data']['textAlign'] = @align
        out['data']['text'] = @text
        # TODO: support the rest
        
        out
      end
    end
  end
end
