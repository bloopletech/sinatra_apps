class User < ActiveRecord::Base
  set_table_name :user_fight_users

  validates_presence_of :username

  before_create :get_details

  def self.pick_winner(user_1, user_2)
    winner = user_1.score > user_2.score ? user_1 : user_2
    loser = user_1.score < user_2.score ? user_1 : user_2
    if winner == loser
      winner = user_1.user_created_at < user_2.user_created_at ? user_1.user_created_at : user_2.user_created_at
      loser = user_1.user_created_at > user_2.user_created_at ? user_1.user_created_at : user_2.user_created_at
    end

    return winner, loser
  end

  def after_find
    if !updated_at || (updated_at < 1.week.ago)
      get_details
      save!
    end
  end

  private
  def get_github_data(path)
    open("http://github.com/api/v2/yaml/#{path}").read
  end
  
  def get_user_details(username)
    YAML.load(get_github_data("user/show/#{username}"))['user']
  end

  def get_repo_details(username)
    YAML.load(get_github_data("repos/show/#{username}"))['repositories']
  end

  def get_details
    begin
      user_details = get_user_details(username)
      repo_details = get_repo_details(username)
    rescue OpenURI::HTTPError => e
      self.errors.add(:username, "does not exist in GitHub") #if it's a 404
      return false
    end

    self.gravatar_id = user_details['gravatar_id']
    self.name = user_details['name']
    self.repo_count = user_details['public_repo_count']
    self.repo_original_watchers_count = repo_details.reject { |repo| repo[:fork] }.sum { |repo| [repo[:watchers], 1].max }
    self.repo_fork_watchers_count = repo_details.select { |repo| repo[:fork] }.sum { |repo| [repo[:watchers], 1].max }
    self.repo_forks_count = repo_details.reject { |repo| repo[:fork] }.sum { |repo| repo[:forks] }
    self.following_count = user_details['following_count'] 
    self.followers_count = user_details['followers_count']
    self.gist_count = user_details['public_gist_count']
    self.user_created_at = user_details['created_at']
    
    # a user with 100 followers, following 100 people
    # with a 100 repos, each repo with 100 watchers and 10 forks
    # 60 of the repos are original and 40 are forks

    self.score = (0.25 * ((0.6 * following_count) + followers_count) +
    repo_original_watchers_count + (0.8 * repo_fork_watchers_count) +
    (10 * repo_forks_count) + (0.025 * gist_count)).round
      
    true
  end
end