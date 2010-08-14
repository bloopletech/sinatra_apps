=begin
class RequestQueue
  @queue = []

  def initialize
    Thread.new do
      while true
        item = nil
        @queue.synchronize do
          item = @queue.shift
        end
        
        
        
        #do work
    

end
=end

require 'open-uri'
require_relative 'user'

class UserFight < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/fight' do
    @user_1 = User.find_or_create_by_username(params[:user_1])
    @user_2 = User.find_or_create_by_username(params[:user_2])

    return erb :failed, :layout => !xhr? if !@user_1.errors.empty? || !@user_2.errors.empty?
    
    @winner, @loser = User.pick_winner(@user_1, @user_2)
  
    erb :fight, :layout => !xhr?
  end

  helpers do
    #Ripped from rails
    def number(n)
      parts = n.to_s.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
      parts.join(".")
    end

    def request_url
      request.url
    end
  end

  private
  def xhr?
    request.xhr?
  end
end