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

module GitFight
  STATS_ATTRS = {
   :score => 'Analyzed Score',
   :followers_count => 'Number of followers',
   :following_count => 'Number of users following',
   :repo_count => 'Number of repos',
   :gist_count => 'Number of gists',
   :repo_original_watchers_count => 'Watcher count for original repos',
   :repo_fork_watchers_count => 'Watcher count for forks',
   :repo_forks_count => 'Fork count for original repos',
   :repo_forks_count => 'Fork count for original repos'
  }
end

require_relative 'user'

class GitFight::GitFight < Sinatra::Base
  get '/' do
    erb :index
  end
  
  get '/fight' do
    @user_1 = get_user(params[:user_1])
    @user_2 = get_user(params[:user_2])

    return erb :failed, :layout => render_layout? if !@user_1.errors.empty? || !@user_2.errors.empty?
    
    @winner, @loser = GitFight::User.pick_winner(@user_1, @user_2)
    
    @user_1_winner_overall = @winner == @user_1
    @user_2_winner_overall = @winner == @user_2
  
    erb :fight, :layout => render_layout?
  end

  get '/user/:user' do
    @user = get_user(params[:user])

    out = {}
    (GitFight::STATS_ATTRS.keys + [:username]).each do |attr|
      val = @user.send(attr)
      out[attr] = params[:commas] == 'true' ? number(val) : val
    end

    response.headers["Content-type"] = "application/json"
    (callback = params[:jsonp] || params[:callback]) ? "#{callback}(#{out.to_json});" : out.to_json
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

  def get_user(username)
    user = GitFight::User.find(:first, :conditions => ['LOWER(username) = ?', username])
    user = GitFight::User.create(:username => username) unless user
    user
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