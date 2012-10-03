#require 'open-uri'

module Textops
end

class Textops::Textops < Sinatra::Base
  get '/' do
    erb :index
  end
  
  post '/download' do
    text = params[:text].gsub(/([ '"])/) { |s| "\\#{$1}" }.gsub("%", "%%")
    foreground_colour = params[:foreground]
    background_colour = params[:background]
    return unless params[:foreground] =~ /^[A-z]+$/ && params[:background] =~ /^[A-z]+$/

    o = Magick::Image.new(2560, 1600) { self.background_color = background_colour }

    draw = Magick::Draw.new
    draw.font_family = 'Helvetica'
    draw.font_style = Magick::NormalStyle
    draw.font_weight = Magick::BoldWeight
    draw.pointsize = 140
    draw.gravity = Magick::CenterGravity
    draw.fill = foreground_colour
    draw.annotate(o, 0, 0, 0, 0, text)

    attachment "desktop-#{Time.now.to_i}.png"
    o.to_blob { self.format = 'png' }
  end
end
