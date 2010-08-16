class AddUsers < ActiveRecord::Migration
  def self.up
    create_table :git_fight_users do |t|
      t.string :username
      t.string :gravatar_id
      t.string :name
      t.integer :repo_count
      t.integer :repo_original_watchers_count
      t.integer :repo_fork_watchers_count
      t.integer :repo_forks_count
      t.integer :following_count
      t.integer :followers_count
      t.integer :gist_count
      t.integer :score
      t.date :user_created_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :git_fight_users
  end
end