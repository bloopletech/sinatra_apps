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

    if @user_!.-+-----------------------------
      erb :failed, :layout => false
      return
    end
    
    @winner, @loser = User.pick_winner(@user_1, @user_2)
  
    erb :fight, :layout => false
  end

  get '/form' do
    erb :form, :layout => false
  end
end