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
    puts "user_1: #{@user_1.inspect}"
    puts "user_2: #{@user_2.inspect}"
    
    @winner, @loser = User.pick_winner(@user_1, @user_2)
  
    erb :fight
  end
end