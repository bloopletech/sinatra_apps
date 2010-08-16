require 'rubygems'
require 'bundler'
Bundler.require
require 'erb'
#require "#{File.dirname(__FILE__)}/active_record_mysql_gone_patch"
require_relative "async_mysql_middleware"
require_relative "standard_methods"

require_relative "configuration"

ActiveRecord::Base.establish_connection(DB_CONFIG)

class Sites
  def self.all
    port = 8999
    Dir.entries("#{File.dirname(__FILE__)}/..").reject { |d| d[0, 1] == '.' || !File.directory?(d) || d == 'lib' || d == 'tmp' }.sort.map do |app_name|
      require_path = "#{File.dirname(__FILE__)}/../#{app_name}/#{app_name}"

      require require_path

      klass = Object.const_get(Object.constants.grep(/^#{app_name.gsub(/_/, '')}$/i)[0])
      
      klass.instance_eval do
        set :app_file, require_path

        set :environment, ENV["ENV"] == "development" ? :development : :production
        set :logging, ENV["ENV"] == "development"
      end

      port += 1 #port starts at 9000
      { :name => app_name, :port => port, :class => klass }
    end
  end
end