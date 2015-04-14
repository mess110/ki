module Ki
  module Middleware
    class DocGenerator < HamlCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if req.doc?
          if view_exists?(req)
            render_haml view_path(req)
          else
            render_haml doc_view_path(req)
          end
        else
          @app.call env
        end
      end

      def doc_view_path path
        File.join(File.dirname(__FILE__), '..', 'views', 'instadoc.haml')
      end
    end
  end
end
