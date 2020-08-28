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
  SyncSign::Widget::Symbolbox.new(x: 16, y: 24, width: 120, height: 100, type: :weather, symbols: [:day_sleet_storm, :day_sunny]),
  SyncSign::Widget::Symbolbox.new(x: 176, y: 24, width: 120, height: 100, type: :brands, symbols: [:github, :linux]),
  SyncSign::Widget::Symbolbox.new(x: 176, y: 72, width: 72, height: 64, type: :solid, symbols: [:wifi, :venus_double])
]

signsvc = SyncSign::Service.new(apikey: apikey)

# make one of the sets of symbols red if the display supports that
if(signsvc.node(nodeid).has_colour?) then
  items[0].colour = :red
end

# assemble the template and send it to the SyncSign service
tmpl = SyncSign::Template.new(items: items)

puts "Sending render request to SyncSign service..."
signsvc.node(nodeid).render(template: tmpl)

