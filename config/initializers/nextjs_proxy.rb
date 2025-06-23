require 'rack/proxy'

class NextjsAuthProxy < Rack::Proxy
  def perform_request(env)
    req = Rack::Request.new(env)

    if req.path.start_with?("/chat") || req.path.start_with?("/_next")
      session = env['rack.session']
      if session[:user_id].blank?
        return [302, { "Location" => "/login" }, []]
      end

      env["HTTP_HOST"] = "next:3001" # コンテナ名ベース
      env["HTTP_X_FORWARDED_HOST"] = "rails:3000"
      env["HTTP_X_FORWARDED_PROTO"] = "http"
      super(env)
    else
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_before 0, NextjsAuthProxy
