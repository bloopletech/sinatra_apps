class MungeAttrs < ActiveRecord::Migration
  def self.up
    add_column :mphm_items, :short_description, :text
  end

  def self.down
    remove_column :mphm_items, :short_description
  end
end