module Lia
end

require_relative 'title'

class Lia::Lia < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/search' do
    q = "#{params[:search]}%"
    @titles = Lia::Title.where(["english_title ILIKE ? OR romaji_title ILIKE ? OR japanese_title ILIKE ?", q, q, q]).order("english_title, romaji_title, japanese_title")
  end
end