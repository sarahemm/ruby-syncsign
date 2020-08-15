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
  SyncSign::Widget::Rectangle.new(x: 8, y: 8, width: 208, height: 60),
  SyncSign::Widget::Textbox.new(x: 16, y: 16, width: 192, height: 44, font: :roboto_slab, size: 24, align: :center, text: "Hello, World!")
]

signsvc = SyncSign::Service.new(apikey: ARGV[0])
tmpl = SyncSign::Template.new(
  background: background,
  items: items
)
puts tmpl.to_s
signsvc.node(ARGV[1]).render(template: tmpl)

