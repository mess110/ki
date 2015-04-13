module Ki
  module Middleware
    class HamlCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if view_exists?(req)
          render_haml view_path(req)
        else
          @app.call env
        end
      end

      def render_haml file_path
        file_contents = File.read(file_path)

        if view_exists? 'layout'
          layout_contents = File.read(view_path('layout'))
        else
          layout_contents = "= yield"
        end

        html = haml(layout_contents).render do
          haml(file_contents).render
        end

        Rack::Response.new(html).finish
      end

      def haml s
        Haml::Engine.new("- extend Ki::Helpers\n" + s)
      end
    end
  end
end
