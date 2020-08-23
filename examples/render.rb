#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

if(!ARGV.length.between?(2, 3)) then
  puts "usage: #{$0} apikey nodeid [render_direct]"
  puts "render_direct: 'yes' to send render requests directly to hub, bypassing the cloud service"
  Kernel.exit 1
end

apikey = ARGV[0]
nodeid = ARGV[1]
render_direct = ARGV[2] ? true : false

items = [
  SyncSign::Widget::Rectangle.new(x: 8, y: 8, width: 208, height: 60, pen_width: 2),
  SyncSign::Widget::Textbox.new(x: 16, y: 16, width: 192, height: 44, font: :roboto_slab, size: 24, align: :center, text: "Hello, World!"),
  SyncSign::Widget::QRCode.new(x: 232, y: 72, scale: 2, text: "Hello, World!"),
  SyncSign::Widget::Line.new(x0: 72, y0: 90, x1: 96, y1: 90),
  SyncSign::Widget::Circle.new(x: 56, y: 96, radius: 16, pen_width: 2),
  SyncSign::Widget::Circle.new(x: 112, y: 96, radius: 16, pen_width: 2)
]

signsvc = SyncSign::Service.new(apikey: apikey, render_direct: render_direct)

# make the text red if the display supports that
if(signsvc.node(nodeid).has_colour?) then
  items[1].colour = :red
end

# assemble the template and send it to the SyncSign service
tmpl = SyncSign::Template.new(items: items)

if(render_direct) then
  if(signsvc.node(nodeid).hub.direct_rendering_capable?) then
    puts "Using direct rendering."
  else
    puts "Unable to use direct rendering, check signhubs.cfg."
  end
end
puts "Sending render request to SyncSign service..."
signsvc.node(nodeid).render(template: tmpl)

