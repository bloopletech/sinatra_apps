class AsyncMysqlMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      status, headers, body = @app.call(env)
    ensure
      ActiveRecord::Base.connection_pool.release_connection
    end
    return status, headers, body
  end
end