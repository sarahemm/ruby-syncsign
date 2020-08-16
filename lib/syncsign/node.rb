module SyncSign
  ##
  # Object that represents a SyncSign node.
  # TODO: Split this up and add support for non-display nodes.
  class Node
    # @return [String] the Node ID of this node.
    attr_reader :id
    # @return [String] the friendly name of this node.
    attr_reader :name
    # @return [Integer] the current battery level of this node (0-100)
    attr_reader :battery
    # @return [Integer] the current signal level of this node (0-100)
    attr_reader :signal
    # @return [String] model of thid node.
    attr_reader :model

    ##
    # Initialize a new Node object (normally only called from Hub#nodes or Service#nodes).
    def initialize(service: nil, id: nil, name: nil, online: nil, battery: nil, signal: nil, model: nil)
      @service = service
      @id = id
      @name = name
      @online = online
      @battery = battery
      @signal = signal
      @model = model
    end

    ##
    # Render a template to this display.
    # @param template [Template] Template to render to this display.
    def render(template: nil)
      @service.api_call(type: :post, path: "/nodes/#{@id}/renders", data: template.to_s)
    end

    ##
    # Return true if the node can display a colour other than black and white.
    def has_colour?
      ['D29R', 'D75'].include? @model
    end

    ##
    # Return true if the node was online during the last information gathering.
    def is_online?
      @online
    end

    ##
    # Parse a JSON description of a single node into a +Node+ object.
    # Normally only called from Hub#nodes or Service#nodes.
    # @api private
    def self.parse(service: nil, nodeinfo: nil)
      Node.new(
        service: service,
        id: nodeinfo['nodeId'],
        name: nodeinfo['name'],
        online: nodeinfo['onlined'],
        battery: nodeinfo['batteryLevel'],
        signal: nodeinfo['signalLevel'],
        model: nodeinfo['model']
      )
    end
    
    ##
    # Parse JSON array of nodes into a collection of Node objects.
    # @param service [SyncSign::Service] Instance of the SyncSign Service class.
    # @param nodeinfo [String] Information about a collection of nodes,
    #   in JSON format.
    # @return [Array] Array of Node objects.
    # @api private
    def self.parse_collection(service: nil, nodeinfo: nil)
      nodes = []
      nodeinfo.each do |node|
        nodes.push Node::parse(service: service, nodeinfo: node)
      end

      nodes
    end
  end
end
