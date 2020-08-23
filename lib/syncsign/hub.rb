module SyncSign
  ##
  # Object that represents a SyncSign hub.
  class Hub
    # @return [String] the serial number of the hub.
    attr_reader :sn
    # @return [String] the friendly name of the hub.
    attr_reader :name
    # @return [String] the IP address or hostname of the hub.
    attr_reader :addr
    # @return [String] the API key of the hub.
    attr_reader :apikey

    ##
    # Initialize a new hub object (normally only called from Service#hubs)
    def initialize(service: nil, sn: nil, name: nil)
      @sn = sn
      @name = name
      @service = service
      load_hub_info
    end
    
    ##
    # Retrieve a collection of all +Node+ objects serviced by this hub.
    def nodes
      SyncSign::Node::parse_collection(service: @service, nodeinfo: @service.api_call(path: "/devices/#{@sn}/nodes"))
    end


    def direct_rendering_capable?
      return @addr && @apikey
    end

    private

    ##
    # Load info about a hub from the config file (IP address and API key)
    def load_hub_info
      cfg_locations = [
        "./signhubs.cfg",
        "#{File::dirname($0)}/signhubs.cfg",
        "/etc/signhubs.cfg"
      ]
      cfgfile = cfg_locations.find { |file| File.exist?(file) }
      return unless cfgfile

      File.open(cfgfile) do |f|
        f.each_line do |line|
          next if line[0] == "#"

          hubinfo = line.split(/\s+/)
          if(@sn == hubinfo[0]) then
            @addr = hubinfo[1]
            @apikey = hubinfo[2]
            return true
          end
        end
      end
    end
  end
end

