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

class GitFight < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/fight' do
    @user_1 = User.find(:first, :conditions => ['LOWER(username) = ?', params[:user_1]])
    @user_1 = User.create(:username => params[:user_1]) unless @user_1

    @user_2 = User.find(:first, :conditions => ['LOWER(username) = ?', params[:user_2]])
    @user_2 = User.create(:username => params[:user_2]) unless @user_2
    raise StandardError.new "sdgsds"

    return erb :failed, :layout => render_layout? if !@user_1.errors.empty? || !@user_2.errors.empty?
    
    @winner, @loser = User.pick_winner(@user_1, @user_2)
  
    erb :fight, :layout => render_layout?
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
  def render_layout?
    !request.xhr?
  end

  public
  configure :production do
    error do
      response.status = 500
      content_type 'text/html'
      erb :failed, :layout => render_layout?
    end
  end
end