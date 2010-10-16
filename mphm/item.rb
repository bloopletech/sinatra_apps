class Array
  def random
    self[rand(length)]
  end
end


class Mphm::Item < ActiveRecord::Base
  set_table_name :mphm_items

  attr_accessor :related_subjects

  API_KEY = 'bc76e88f9fab014'
=begin
  def self.all_in_api()
    data = Yajl::Parser.parse(open("http://api.powerhousemuseum.com/api/v1/item/json/?api_key=#{API_KEY}").read)
    #check status and raise error

    item = data["item"]
    Item.new(:title => item["title"], :short_description => item["description"], :thumbnail_url => "", :url => item["url"])
  end
=end
  #it is the powerhouse id
  def self.from_api(id)
    data = get("item/#{id}/json/?api_key=#{API_KEY}&limit=#{NUM_ITEMS}")
    #check status and raise error

    item_from_hash(data["item"])
  end

  NUM_ITEMS = 6

  CACHE = {}
  def self.get(url)
    if CACHE.key? url
      puts "Cache hit for #{url}"
      CACHE[url]
    else
      puts "Cache miss for #{url}"
      puts "going to http://api.powerhousemuseum.com/api/v1/#{url}"
      CACHE[url] = Yajl::Parser.parse(open("http://api.powerhousemuseum.com/api/v1/#{url}").read)
    end
  end

  def related_items


    items = []

    #related subjects
    #pick first for each related up to 5
    related_subjects[0, NUM_ITEMS - 1].each do |subject|
      data = self.class.get("subject/json/?api_key=#{API_KEY}&name=#{CGI.escape subject}")
      _items = self.class.get("subject/#{data['subjects'][0]['id']}/items/json/?api_key=#{API_KEY}&limit=10")['items']
      interim = _items.first
      interim = _items.last if interim['id'] == mphm_id

      items << self.class.item_from_hash(interim)
    end

    #pick random related
    data = self.class.get("item-name/json/?api_key=#{API_KEY}&name=#{CGI.escape(mphm_name)}")
    id = data["item_names"][0]["id"]
    data = self.class.get("item-name/#{id}/items/json/?api_key=#{API_KEY}")
    items << self.class.item_from_hash(data["items"].random)
    
    items
  end

  #Should be private
  def self.item_from_hash(hash)
    thumbnail_url = begin
      get(hash["multimedia_uri"].gsub("/api/v1/", ""))['multimedia'][0]['images']['thumbnail']['url']
    rescue
      nil
    end

    data = { :title => hash['title'], :short_description => hash['summary'], :mphm_id => hash['id'], :thumbnail_url => thumbnail_url, :url => "http://www.powerhousemuseum.com/collection/database/?irn=#{hash['id']}" }
    
    if hash['names']
      data.merge!(:mphm_name => hash['names'][0], :description => hash['description'])
    end

    item = Mphm::Item.new(data)
    item.related_subjects = hash['subjects'] if hash.key? 'subjects'
    item
  end
end