#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

if(!ARGV[0]) then
  puts "usage: #{$0} apikey"
  Kernel.exit 1
end

signsvc = SyncSign::Service.new(apikey: ARGV[0])
pp signsvc.nodes

