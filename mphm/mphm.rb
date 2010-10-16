ActiveRecord::Base.include_root_in_json = false #Hack Hack Hack

module Mphm
end

require_relative 'item'

class Mphm::Mphm < Sinatra::Base
  get '/start' do
    IDS = [213101, 155534, 19352, 85075, 347010, 304767, 343544, 7177, 98331, 259537]

    IDS.map do |id|
      Mphm::Item.from_api(id)
    end.to_json
  end

  get '/related/item/:id' do
    item = Mphm::Item.from_api(params[:id])
    item.related_items.to_json
  end
end