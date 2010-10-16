module Mphm
end

require_relative 'item'

class Mphm::Mphm < Sinatra::Base
  get '/start' do
    return <<-EOF
[
  {
    "title": "The title of the frangible item",
    "short_description": "The short spelling description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "1"
  },
  
  {
    "title": "The title of the runcible item",
    "short_description": "The short purple description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "2"
  },
  
  {
    "title": "The title of the document item",
    "short_description": "The short spoon description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "3"
  }
]
EOF
  end

  get '/related/item/:id' do
    return <<-EOF
[
  {
    "title": "The title of the frangible item",
    "short_description": "The short spelling description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "1"
  },
  
  {
    "title": "The title of the runcible item",
    "short_description": "The short purple description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "2"
  },
  
  {
    "title": "The title of the document item",
    "short_description": "The short spoon description.",
    "thumbnail_url": "http://google.com/",
    "url": "http://google.com/",
    "importance": 100,
    "id": "3"
  }
]
EOF
  end
end