module Ki
  module Middleware
    class DocGenerator < HamlCompiler
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        if custom_check(req)
          if view_exists?(req)
            html = render_haml_file view_path(req)
          else
            html = render_haml_file custom_view_path
          end
          Rack::Response.new(html).finish
        else
          @app.call env
        end
      end

      def custom_check(req)
        req.doc?
      end

      def custom_view_path
        File.join(File.dirname(__FILE__), '..', 'views', 'instadoc.haml')
      end
    end
  end
end
