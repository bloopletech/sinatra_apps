#require 'json'
module VideoEncoding
end

class VideoEncoding::VideoEncoding < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/' do
  
  
  end
end