require 'json'

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
      attr_accessor :w, :h

      def initialize(x: nil, y: nil, w: nil, h: nil)
        @width = w
        @height = h
        super(x: x, y: y)
      end
    end

    class ColourBox < Box
      attr_accessor :colour, :bgcolour

      def initialize(x: nil, y: nil, w: nil, h: nil, colour: :black, bgcolour: :white)
        @colour = colour
        @bgcolour = bgcolour
        super(x: x, y: y)
      end
    end

    class Rectangle < ColourBox
      attr_accessor :pen_width

      def initialize(x: nil, y: nil, w: nil, h: nil, colour: :black, bgcolour: :white, pen_width: 1)
        @pen_width = pen_width
        super(x: x, y: y, w: w, h: h)
      end
      
      def to_a
        out = {}
        out['type'] = 'RECTANGLE'
        out['data'] = {}
        out['data']['block'] = {x: @x, y: @y, w: @width, h: @height}
        # TODO: support the rest
        
        out
      end
    end

    class Textbox < ColourBox
      attr_accessor :font, :size, :bold, :id, :align, :text

      def initialize(x: nil, y: nil, w: nil, h: nil, colour: :black, bgcolour: :white, font: nil, size: nil, bold: false, id: nil, align: :left, text: nil)
        @font = font
        @size = size
        @bold = bold
        @id = id
        @align = align
        @text = text
        super(x: x, y: y, w: w, h: h, colour: colour, bgcolour: bgcolour)
      end

      def to_a
        out = {}
        out['type'] = 'TEXT'
        out['data'] = {}
        out['data']['font'] = @font # TODO: do fonts better
        out['data']['block'] = {x: @x, y: @y, w: @width, h: @height}
        out['data']['text'] = @text
        # TODO: support the rest
        
        out
      end
    end
  end
end
