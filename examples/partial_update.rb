#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

unless(ARGV.length == 2) then
  puts "usage: #{$0} apikey nodeid"
  Kernel.exit 1
end

apikey = ARGV[0]
nodeid = ARGV[1]

items = [
  SyncSign::Widget::Textbox.new(x: 16, y: 16, width: 192, height: 44, font: :roboto_slab, size: 24, align: :center, text: "Hello, World!"),
]

signsvc = SyncSign::Service.new(apikey: apikey)

# assemble the template and send it to the SyncSign service
tmpl = SyncSign::Template.new(items: items)

puts "Sending render request to SyncSign service..."
signsvc.node(nodeid).render(template: tmpl)

puts "Waiting while first update renders..."
sleep 45

items = [
  SyncSign::Widget::Textbox.new(x: 16, y: 72, width: 192, height: 44, font: :roboto_slab, size: 24, align: :center, text: "Hello, again!"),
]

tmpl = SyncSign::Template.new(items: items)
puts "Sending partial update request to SyncSign service..."
signsvc.node(nodeid).render(template: tmpl, partial: true)

