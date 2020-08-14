module SyncSign
  class Node
    attr_reader :id, :name, :battery, :signal
    attr_accessor :online

    def initialize(service: nil, id: nil, name: nil, online: nil, battery: nil, signal: nil)
      @service = service
      @id = id
      @name = name
      @online = online
      @battery = battery
      @signal = signal
    end

    def render(template: nil)
      @service.api_call(type: :post, path: "/nodes/#{@id}/renders", data: template.to_s)
    end

    def self.parse(service: nil, nodeinfo: nil)
      Node.new(
        service: service,
        id: nodeinfo['nodeId'],
        name: nodeinfo['name'],
        online: nodeinfo['onlined'],
        battery: nodeinfo['batteryLevel'],
        signal: nodeinfo['signalLevel']
      )
    end
  end

  class Nodes
    def self.parse(service: nil, nodeinfo: nil)
      nodes = []
      nodeinfo.each do |node|
        nodes.push Node::parse(service: service, nodeinfo: node)
      end

      nodes
    end
  end
end
