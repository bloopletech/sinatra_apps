class Lia::Title < ActiveRecord::Base
  set_table_name  :lia_titles

  def title
    [romaji_title, english_title, japanese_title].detect { |t| !t.nil? and !t.blank? }
  end

  def titles
    [romaji_title, english_title, japanese_title].select { |t| !t.nil? and !t.blank? }.uniq.join(" / ")
  end
end