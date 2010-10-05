module Htt8ball
end

class Htt8ball::Htt8ball < Sinatra::Base
  get '/' do
    codes = Rack::Utils::HTTP_STATUS_CODES
    code = codes.keys[rand(codes.length)]
    full_status = "#{code} #{codes[code]}"
    halt [code, %Q{
<!DOCTYPE html>
<html>
  <head>
    <title>#{full_status}</title>
  </head>
  <body>
    <h1>The htt8ball's answer to your question is:</h1>
    <h1>#{full_status}</h1>
  </body>
</html>}]
  end
end