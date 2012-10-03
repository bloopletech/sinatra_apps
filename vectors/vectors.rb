module Vectors
end

class Vectors::Vectors < Sinatra::Base
  get '/' do
    erb :index
  end

  post '/' do
    doc = Nokogiri::XML.parse(params[:file].read)
    
    svg = doc.css("svg").first
    
    width = svg['width'].to_i
    height = svg['height'].to_i
    
    #scale
    
    svg['width'] = "#{new_width}px"
    svg['height'] = "#{new_height}px"
    
    
    unique = SecureRandom.hex(10)
    in_filename = "#{Dir.tmpdir}/#{unique}.svg"
    out_filename = "#{Dir.tmpdir}/#{unique}.png"
    File.open(in_filename, "w") { |f| f << doc.to_s }
    
    system("rsvg #{in_filename} #{out_filename}")
    
    response.body = File.read(out_filename)
    
    File.delete(in_filename)
    File.delete(out_filename)
  end
end