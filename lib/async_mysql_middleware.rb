class AsyncMysqlMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      puts "At beginning of request #{ActiveRecord::Base.connection_pool.connections.length}"
      #Camping::Models::Base.connection_pool.clear_stale_cached_connections!
      #Time.zone = TIME_ZONE
      #z = Time.now

      status, headers, body = @app.call(env)

      #puts "time to serve #{e.PATH_INFO}: #{Time.now - z}"
    ensure
      ActiveRecord::Base.connection_pool.release_connection
      puts "At end of request #{ActiveRecord::Base.connection_pool.connections.length}"
    end
    return status, headers, body
  end
end