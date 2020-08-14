require 'net/http'
require 'json'

module SyncSign
  class Service
    def initialize(apikey: null)
      @apikey = apikey
      @baseurl = "https://api.sync-sign.com/v2/key/#{apikey}"
    end

    def account_info()
      api_call()
    end

    def hubs()
      hubs = []
      hub_data = api_call(path: "/devices")
      hub_data.each do |hub|
        hubs.push Hub.new(
          service: self,
          sn: hub['sn'],
          name: hub['info']['friendlyName']
        )
      end

      hubs
    end

    def nodes()
      Nodes::parse(service: self, nodeinfo: api_call(path: "/nodes"))
    end

    def node(id)
      Node::parse(service: self, nodeinfo: api_call(path: "/nodes/#{id}"))
    end

    def api_call(type: :get, path: "", data: "")
      apiurl = URI.parse("#{@baseurl}#{path}")
      http_obj = Net::HTTP.new(apiurl.host, apiurl.port)
      http_obj.use_ssl = true
      response = nil
      http_obj.start() do |http|
        req = nil
        if(type == :get) then
          req = Net::HTTP::Get.new(apiurl.request_uri)
        else
          req = Net::HTTP::Post.new(apiurl.request_uri)
          req.body = data
          req['Content-Type'] = 'application/json'
        end
        response = http.request(req)
      end
      # TODO: handle failure
      JSON.parse(response.read_body)['data']
    end
  end
end

