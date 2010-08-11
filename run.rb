#!/usr/bin/env ruby

require_relative 'lib/shared'

threads = []

Sites.all.each do |site|
  rb = Rack::Builder.app do
    use AsyncMysqlMiddleware
    run site[:class]
  end

  rs = Rack::Server.new(:Port => site[:port], :server => 'mongrel')
  rs.instance_variable_set(:@app, rb)
  threads << Thread.new { rs.start }

  puts "#{site[:name]} running on #{site[:port]}" if $DEBUG
end

threads.each { |t| t.join }