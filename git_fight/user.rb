class GitFight::User < ActiveRecord::Base
  set_table_name :git_fight_users
  
  after_find :check_details!

  validates_presence_of :username

  before_create :get_details

  def self.pick_winner(user_1, user_2, method = :score)
    winner = user_1.send(method) > user_2.send(method) ? user_1 : user_2
    loser = user_1 == winner ? user_2 : user_1
    if winner == loser
      winner = user_1.user_created_at < user_2.user_created_at ? user_1.user_created_at : user_2.user_created_at
      loser = user_1.user_created_at > user_2.user_created_at ? user_1.user_created_at : user_2.user_created_at
    end

    return winner, loser
  end

  def self.is_user_winner?(user_in_question, other_user, method = :score)
    pick_winner(user_in_question, other_user, method).first == user_in_question
  end

  private
  def get_github_data(path)
    open("https://api.github.com/#{path}").read
  end
  
  def get_user_details(username)
    JSON.parse(get_github_data("users/#{username}"))
  end

  def get_repo_details(username)
    JSON.parse(get_github_data("users/#{username}/repos"))
  end

  def get_details
    begin
      user_details = get_user_details(username)
      sleep 1
      repo_details = get_repo_details(username)
      sleep 1
    rescue OpenURI::HTTPError => e
      self.errors.add(:username, "does not exist in GitHub") #if it's a 404
      return false
    rescue Exception => e
      return false
    end

    self.username = user_details['login']
    self.gravatar_id = user_details['avatar_url']
    self.name = user_details['name']
    self.repo_count = user_details['public_repos']
    self.repo_original_watchers_count = repo_details.reject { |repo| repo["fork"] }.sum { |repo| [repo["watchers"], 1].max }
    self.repo_fork_watchers_count = repo_details.select { |repo| repo["fork"] }.sum { |repo| [repo["watchers"], 1].max }
    self.repo_forks_count = repo_details.reject { |repo| repo["fork"] }.sum { |repo| repo["forks"] }
    self.following_count = user_details['following'] 
    self.followers_count = user_details['followers']
    self.gist_count = user_details['public_gists']
    self.user_created_at = user_details['created_at']
    
    # a user with 100 followers, following 100 people
    # with a 100 repos, each repo with 100 watchers and 10 forks
    # 60 of the repos are original and 40 are forks

    self.score = (0.25 * ((0.6 * following_count) + followers_count) +
    repo_original_watchers_count + (0.8 * repo_fork_watchers_count) +
    (10 * repo_forks_count) + (0.025 * gist_count)).round
      
    true
  end

  def check_details!
    if updated_at < 1.week.ago
      get_details
      save!
    end
  end
end