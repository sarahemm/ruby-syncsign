#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

if(!ARGV[0]) then
  puts "usage: #{$0} apikey"
  Kernel.exit 1
end

signsvc = SyncSign::Service.new(apikey: ARGV[0])
signsvc.nodes.each do |node|
  puts "Node #{node.id}: #{node.name || '(unnamed)'}"
  puts "\tModel: #{node.model}"
  puts "\tHas Colour: #{node.has_colour? ? "Yes" : "No"}"
  puts "\tIs Online: #{node.is_online? ? "Yes" : "No"}"
  puts "\tBattery: #{node.battery || 'Unavailable'}"
  puts "\tSignal: #{node.signal || 'Unavailable'}\n\n"
end

