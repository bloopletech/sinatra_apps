class AddImportance < ActiveRecord::Migration
  def self.up
    add_column :mphm_items, :importance, :integer
  end

  def self.down
    remove_column :mphm_items, :importance
  end
end