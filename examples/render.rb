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
  'type': 'TEXT',
  'data': {
    'font': 'ROBOTO_SLAB_24',
    'block': {
      'x': 0,
      'y': 0,
      'w': 200,
      'h': 100
    },
    'text': "Hello, World!"
  }
]

signsvc = SyncSign::Service.new(apikey: ARGV[0])
tmpl = SyncSign::Template.new(
  background: background,
  items: items
)
signsvc.node(ARGV[1]).render(template: tmpl)

