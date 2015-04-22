module Ki
  module Middleware
    class HamlCompiler
      include BaseMiddleware
      include Helpers::HamlCompiler

      def call(env)
        req = BaseRequest.new env
        if view_exists?(req)
          html = render_haml_file view_path(req)
          Rack::Response.new(html).finish
        else
          @app.call env
        end
      end
    end
  end
end
