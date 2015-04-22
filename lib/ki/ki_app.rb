module Ki
  class KiApp
    include Middleware::Helpers::HamlCompiler
    include Middleware::Helpers::View

    def call(env)
      if view_exists?(not_found_view_path)
        path = not_found_view_path
      else
        path = custom_view_path
      end
      html = render_haml_file(path).strip!
      Rack::Response.new(html).finish
    end

    def not_found_view_path
      view_path('404')
    end

    def custom_view_path
      File.join(File.dirname(__FILE__), 'views', '404.haml')
    end
  end
end
