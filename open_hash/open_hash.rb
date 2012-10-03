module OpenHash
end

class OpenHash::OpenHash < Sinatra::Base
  get '/:key' do
    mc.get(params[:key])
  end

  put '/:key' do
    request.body.rewind
    mc.set(params[:key], request.body.read)
    200
  end

  private
  def mc
#    @mc ||= MemCache.new('localhost:21201', :value_max_bytes => (1024 * 1024 * 5))
    @mc ||= MemCache.new('localhost:21201', :check_size => false)
  end

  public
  configure :production do
    error do
      response.status = 500
    end
  end
end
