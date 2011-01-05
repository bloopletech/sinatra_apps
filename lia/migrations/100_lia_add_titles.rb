class LiaAddTitles < ActiveRecord::Migration
  def self.up
    create_table :lia_titles do |t|
      t.string :english_title
      t.string :romaji_title
      t.string :japanese_title
      t.boolean :licensed
      t.string :licensor
      
      t.timestamps
    end
  end

  def self.down
    drop_table :lia_titles
  end
end