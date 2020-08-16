module SyncSign
  ##
  # Object that represents a SyncSign hub.
  class Hub
    # @return [String] the serial number of the hub.
    attr_reader :sn
    # @return [String] the friendly name of the hub.
    attr_reader :name
    
    ##
    # Initialize a new hub object (normally only called from Service#hubs)
    def initialize(sn: null, name: null, service: null)
      @sn = sn
      @name = name
      @service = service
    end
    
    ##
    # Retrieve a collection of all +Node+ objects serviced by this hub.
    def nodes
      SyncSign::Node::parse_collection(service: @service, nodeinfo: @service.api_call(path: "/devices/#{@sn}/nodes"))
    end
  end
end

