# frozen_string_literal: true

module Ki
  module Middleware
    class InitMiddleware
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        if req.root?
          if public_file_exists? 'index.html'
            env['PATH_INFO'] = '/index.html'
            Rack::File.new(Ki::PUBLIC_PATH).call env
          else
            resp = Rack::Response.new
            resp.redirect('/index')
            resp.finish
          end
        else
          env['CONTENT_TYPE'] = 'application/json' if format_of(req) == 'json'
          @app.call env
        end
      end
    end
  end
end
