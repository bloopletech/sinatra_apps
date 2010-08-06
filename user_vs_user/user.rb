class User < ActiveRecord::Base
  establish_connection(:adapter => 'sqlite3', :dbfile =>  'db.sqlite3')
end