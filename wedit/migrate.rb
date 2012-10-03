require 'rubygems'
require 'nokogiri'
require 'memcache'

doc = Nokogiri::XML.parse(File.read("temp.xml"))
mem = MemCache.new('localhost:21201', :check_size => false)

doc.css("row").each do |row|
  key = row.css("field[name=key]").text
  mem.set("wedit-document-#{key}", row.css("field[name=text]").text)
  mem.set("wedit-document-#{key}-last-modified", row.css("field[name=last_modified]").text)
end
=begin
resiults.each do |row|
  mem.set("wedit-document-#{row["key"]}", row["text"])
  mem.set("wedit-document-#{row["key"]}-last-modified", row["last_modified"])
end
=end
