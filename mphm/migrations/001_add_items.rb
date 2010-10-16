class AddItems < ActiveRecord::Migration
  def self.up
    create_table :mphm_items do |t|
      t.string :mphm_id
      t.text :title
      t.text :description
      t.text :thumbnail_url

      t.timestamps
    end
  end

  def self.down
    drop_table :mphm_items
  end
end