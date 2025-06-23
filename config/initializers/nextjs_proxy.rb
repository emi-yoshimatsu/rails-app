require "rack/proxy"

class NextjsProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)

    if request.path.start_with?("/chat") || request.path.start_with?("/_next")
      env["HTTP_HOST"] = "localhost:3001"
      env["PATH_INFO"] = request.fullpath
      env["HTTP_X_FORWARDED_HOST"] = "localhost:3000"
      super(env)
    else
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_before(0, NextjsProxy)
