require 'rubygems'
require 'mysql2'
require 'memcache'

sql = Mysql2::Client.new(:host => "localhost", :username => "root")
mem = MemCache.new('localhost:21201', :check_size => false)

sql.query("USE wedit")
results = sql.query("SELECT * FROM documents")
results.each do |row|
  mem.set("wedit-document-#{row["key"]}", row["text"])
  mem.set("wedit-document-#{row["key"]}-last-modified", row["last_modified"])
end

