module SyncSign
  class Widget
    ##
    # A widget that draws button labels for the 4.2" display.
    class ButtonLabels
      # @return [Array] Up to 4 strings of 17 characters each, to label the buttons with.
      attr_accessor :labels
      # @return [Array] Up to 4 boolean values showing whether each button should be reverse colours.
      attr_accessor :reversed
      
      ##
      # Initialize a new Button Labels widget.
      # @param labels [Array] Up to 4 strings of 17 characters each, to label the buttons with.
      # @param reversed [Array] Up to 4 boolean values showing whether each button should be reverse colours (white on black). Default is black on white.
      def initialize(labels: [], reversed: [])
        # TODO: validate <= 17 characters in each label
        @labels = labels
        @reversed = reversed
      end

      ##
      # Convert the widget into an array for sending to the SyncSign service.
      def to_a
        label_arr = []
        (0..3).each do |idx|
          label_arr[idx] = {
            :title => @labels[idx] || "",
            :style => @reversed[idx] || 'DISABLED'
          }
        end

        {
          'type': 'BOTTOM_CUSTOM_BUTTONS',
          'data': {
            'list': label_arr
          }
        }
      end

      def ==(other)
        @labels == other.labels &&
        @reversed == other.reversed
      end
    end
  end
end
