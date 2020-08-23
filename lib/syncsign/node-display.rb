module SyncSign
  ##
  # Object that represents a SyncSign display node.
  class Display < Node
    ##
    # Render a template to this display.
    # @param template [Template] Template to render to this display.
    def render(template: nil)
      @service.api_call(type: :post, path: "/nodes/#{@id}/renders", data: template.to_s, node: self, direct: @service.direct_rendering?)
    end

    ##
    # Return true if the node can display a colour other than black and white.
    def has_colour?
      ['D29R', 'D75'].include? @model
    end
  end
end
