#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

if(!ARGV[0]) then
  puts "usage: #{$0} apikey nodeid"
  Kernel.exit 1
end

background = {
  'bgColor': 'WHITE',
}

items = [
  SyncSign::Widget::Textbox.new(x: 10, y: 10, w: 200, h: 100, font: :roboto_slab, text: "Hello, World!"),
  SyncSign::Widget::Rectangle.new(x: 0, y: 0, w: 220, h: 120)
]

#items = [
#  'type': 'TEXT',
#  'data': {
#    'font': 'ROBOTO_SLAB_24',
#    'block': {
#      'x': 0,
#      'y': 0,
#      'w': 200,
#      'h': 100
#    },
#    'text': "Hello, World!"
#  }
#]

#signsvc = SyncSign::Service.new(apikey: ARGV[0])
tmpl = SyncSign::Template.new(
  background: background,
  items: items
)
puts tmpl.to_s
#signsvc.node(ARGV[1]).render(template: tmpl)

