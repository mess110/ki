module Ki
  module Middleware
    class DocGenerator < HamlCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if custom_check(req)
          if view_exists?(req)
            render_haml view_path(req)
          else
            render_haml custom_view_path
          end
        else
          @app.call env
        end
      end

      def custom_check req
        req.doc?
      end

      def custom_view_path
        File.join(File.dirname(__FILE__), '..', 'views', 'instadoc.haml')
      end
    end
  end
end
