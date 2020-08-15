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

    class Line
      attr_accessor :x0, :y0, :x1, :y1, :bgcolour, :colour, :pattern

      def initialize(x0: nil, y0: nil, x1: nil, y1: nil, bgcolour: :white, colour: :black, pattern: :solid)
        @x0 = x0
        @y0 = y0
        @x1 = x1
        @y1 = y1
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        @pattern = pattern.to_s.upcase
      end
      
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

    class Circle < Item
      attr_accessor :radius, :bgcolour, :colour, :pattern

      def initialize(x: nil, y: nil, radius: nil, bgcolour: :white, colour: :black, fillpattern: :hollow, strokepattern: :solid)
        @radius = radius
        @colour = colour.to_s.upcase
        @bgcolour = bgcolour.to_s.upcase
        @fillpattern = fillpattern.to_s.upcase
        @strokepattern = strokepattern.to_s.upcase
        super(x: x, y:y)
      end
      
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

    class QRCode < Item
      attr_accessor :scale, :version, :ecclevel, :text
      
      def initialize(x: nil, y: nil, scale: 4, version: 2, ecclevel: :medium, text: nil)
        @scale = scale
        @version = version
        @ecclevel = ecclevel
        @text = text

        super(x: x, y: y)
      end

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
