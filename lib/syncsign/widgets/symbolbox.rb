module SyncSign
  class Widget
    ##
    # A widget that draws a box of symbols.
    class Symbolbox < Box
      attr_accessor :type, :symbols

      ##
      # Initialize a new symbol box widget.
      # @param x [Integer] horizontal position of the left side of the symbol box.
      # @param y [Integer] vertical position of the top of the symbol box.
      # @param width [Integer] how wide the symbl box should be.
      # @param height [Integer] how tall the symbol box should be.
      # @param colour [Symbol] The symbol colour used for the box.
      # @param bgcolour [Symbol] The background colour used for the symbol box.
      # @param type [Symbol] The type of symbols for this box (:weather, :solid, or :brands).
      # @param symbols [Array] The list of symbols to include in the box.
      # @param id [String] An ID value to attach to the symbol box.
      def initialize(x: nil, y: nil, width: nil, height: nil, colour: :black, bgcolour: :white, type: nil, id: nil, symbols: [])
        raise(AlignmentException, "Symbolbox: either y or height must be a multiple of 8") if y % 8 != 0 and height % 8 != 0
        raise(AlignmentException, "Symbolbox: width must be a multiple of 8") if width % 8 != 0
        @type = type
        raise(ArgumentError, "Symbolbox: Available types are :weather, :solid, or :brands.") unless [:weather, :solid, :brands].include? type
        @id = id
        @symbols = symbols
        super(x: x, y: y, width: width, height: height, colour: colour, bgcolour: bgcolour)
      end

      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        symbol_type = nil
        case @type
          when :weather
            symbol_type = "ICON_WEATHER"
          when :solid
            symbol_type = "ICON_FA_SOLID"
          when :brands
            symbol_type = "ICON_FA_BRANDS"
        end

        text = decode_symbols(@symbols)
        {
          'type': 'TEXT',
          'data': {
            'block': {x: @x, y: @y, w: @width, h: @height},
            'textColor': @colour.to_s.upcase,
            'font': symbol_type,
            'text': text
          }
        }
      end

      private

      def decode_symbols(symbol_arr)
        symbol_str = ""
        symbol_arr.each do |symbol|
          raise ArgumentError, "No such symbol :#{symbol.to_s} in type '#{@type}'!" unless SyncSign::Widget::Symbols::SYMBOL_LIBRARY[@type][symbol]
          symbol_str += [SyncSign::Widget::Symbols::SYMBOL_LIBRARY[type][symbol]].pack('U*')
        end

        symbol_str
      end
    end
  end
end
