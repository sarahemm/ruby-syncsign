module SyncSign
  class Hub
    attr_reader :sn, :name
    
    def initialize(sn: null, name: null, service: null)
      @sn = sn
      @name = name
      @service = service
    end

    def nodes()
      SyncSign::Nodes::parse(service: @service, nodeinfo: @service.api_call(path: "/devices/#{@sn}/nodes"))
    end
  end
end

