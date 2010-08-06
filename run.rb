#!/usr/bin/env ruby

require 'lib/shared'

threads = []

Sites.all.each do |site|
  rs = Rack::Server.new(:Port => site[:port], :server => 'mongrel')
  rs.instance_variable_set(:@app, site[:class])
  threads << Thread.new { rs.start }

  puts "#{site[:name]} running on #{site[:port]}" if $DEBUG
end

threads.each { |t| t.join }