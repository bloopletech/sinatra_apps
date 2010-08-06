require 'rubygems'
require 'mongrel'
require 'sinatra/base'
require 'erb'

class Sites
  def self.all
    port = 8999
    Dir.entries("#{File.dirname(__FILE__)}/..").reject { |d| d[0, 1] == '.' || !File.directory?(d) || d == 'lib' }.sort.map do |app_name|
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