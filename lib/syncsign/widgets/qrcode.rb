module SyncSign
  class Widget
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

      def ==(other)
        @x == other.x               &&
        @y == other.y               &&
        @scale == other.scale       &&
        @version == other.version   &&
        @ecclevel == other.ecclevel &&
        @text == other.text
      end
    end
  end
end
