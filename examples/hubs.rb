#!/usr/bin/ruby

$:.unshift "#{File.dirname(__FILE__)}/../lib"

require 'syncsign.rb'
require 'pp'

if(!ARGV[0]) then
  puts "usage: #{$0} apikey"
  Kernel.exit 1
end

signsvc = SyncSign::Service.new(apikey: ARGV[0])
signsvc.hubs.each do |hub|
  if(hub.direct_rendering_capable?) then
    puts "Hub #{hub.sn}: #{hub.name || '(unnamed)'} (direct rendering capable)"
  else
    puts "Hub #{hub.sn}: #{hub.name || '(unnamed)'}"
  end
end

