class Mphm::Item < ActiveRecord::Base
  set_table_name :mphm_items


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
    data = Yajl::Parser.parse(open("http://api.powerhousemuseum.com/api/v1/item/#{id}/json/?api_key=#{API_KEY}").read)
    #check status and raise error

    item_from_hash(data["item"])
  end

  def related_items
    data = Yajl::Parser.parse(open("http://api.powerhousemuseum.com/api/v1/item-name/json/?api_key=#{API_KEY}&name=#{CGI.escape(mphm_name)}").read)
    
    
    id = data["item_names"][0]["id"]

    data = Yajl::Parser.parse(open("http://api.powerhousemuseum.com/api/v1/item-name/#{id}/items/json/?api_key=#{API_KEY}").read)

    data["items"].map { |item_hash| self.class.item_from_hash(item_hash) }[0, 10]
  end

  #Should be private
  def self.item_from_hash(hash)
    data = { :title => hash['title'], :short_description => hash['summary'], :mphm_id => hash['id'], :thumbnail_url => hash["multimedia_uri"] }
    
    if hash['names']
      data.merge!(:mphm_name => hash['names'][0], :description => hash['description'])
    end

    Mphm::Item.new(data)
  end
end