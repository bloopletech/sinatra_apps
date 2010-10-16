ActiveRecord::Base.include_root_in_json = false #Hack Hack Hack

module Mphm
end

require_relative 'item'

class Mphm::Mphm < Sinatra::Base
  get '/' do
    redirect '/index.html'
  end

  get '/start' do
    IDS = [213101, 155534, 19352, 85075, 347010, 304767]#, 343544, 7177, 98331, 259537]

    IDS.map do |id|
      Mphm::Item.from_api(id)
    end.to_json
  end

  get '/related/item/:id' do
    item = Mphm::Item.from_api(params[:id])
    item.related_items.to_json
  end

  get '/show/:id' do
    @item = Mphm::Item.from_api(params[:id])
    erb :show
  end

  helpers do
   def simple_format(text, html_options={}, options={})
     text = '' if text.nil?
     start_tag = "<p>"
     text.gsub!(/\r\n?/, "\n")                    # \r\n and \r -> \n
     text.gsub!(/\n\n+/, "</p>\n\n#{start_tag}")  # 2+ newline  -> paragraph
     text.gsub!(/([^\n]\n)(?=[^\n])/, '\1<br />') # 1 newline   -> br
     text.insert 0, start_tag
     text << "</p>"
     text
    end
  end
end