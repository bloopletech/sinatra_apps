class AddUrl < ActiveRecord::Migration
  def self.up
    add_column :mphm_items, :url, :text
  end

  def self.down
    drop_table :mphm_items, :url
  end
end