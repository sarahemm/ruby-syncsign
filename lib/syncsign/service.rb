require 'net/http'
require 'json'

##
# The SyncSign module contains everything needed to interface with the
# SyncSign cloud server and display information on their e-paper displays.
module SyncSign
  ##
  # Raised if an error occurs communicating with the SyncSign cloud service.
  class APICallException < StandardError
  end

  ##
  # Object that communicates with the SyncSign cloud service.
  class Service
    ##
    # Set up a new connection to the SyncSign cloud service.
    # @param apikey [String] the API key provided through the SyncSign portal.
    # @param render_direct [Boolean] try to send renders directly to the hub,
    # bypassing the cloud service.
    def initialize(apikey: nil, render_direct: false)
      @apikey = apikey
      @directrender = render_direct
      @baseurl = "https://api.sync-sign.com/v2/key/#{apikey}"
    end

    ##
    # Retrieve an array of information about the SyncSign cloud service account
    # associated with this object.
    def account_info()
      api_call()
    end
    
    ##
    # Retrieve a collection of all +Hub+ objects registered under the account.
    def hubs
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

    ##
    # Retrieve a collection of all +Node+ objects registered under the account.
    def nodes()
      Node::parse_collection(service: self, nodeinfo: api_call(path: "/nodes"))
    end

    ##
    # Retrieve a single +Node+ object with the given id.
    # @param id [String] Node ID to retrieve the object for.
    def node(id)
      Node::parse(service: self, nodeinfo: api_call(path: "/nodes/#{id}"))
    end

    ##
    # Query whether we are rendering direct to the hub or via the cloud.
    def direct_rendering?
      @directrender
    end

    ##
    # Make a call to the SyncSign cloud service.
    # @param type [Symbol] The HTTP method to use, either :get or :put.
    # @param path [String] The path to make the API call to, minus the base path.
    # @param data [String] The POST data to send with the API call.
    # @param direct [Boolean] Whether to try to send the call directly to the hub,
    # bypassing the cloud service.
    # @param node [Node] The SyncSign node that this request is associated with.
    # Optional unless using direct rendering, in which case it is required.
    # @api private
    def api_call(type: :get, path: "", data: "", direct: false, node: nil)
      baseurl = @baseurl
      baseurl = "http://#{node.hub.addr}/key/#{node.hub.apikey}" if direct and node.hub.direct_rendering_capable?
      apiurl = URI.parse("#{baseurl}#{path}")
      http_obj = Net::HTTP.new(apiurl.host, apiurl.port)
      http_obj.use_ssl = baseurl.include?("https")
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
      if(response.code.to_i != 200) then
        raise APICallException, response.read_body
      end
      JSON.parse(response.read_body)['data']
    end
  end
end

