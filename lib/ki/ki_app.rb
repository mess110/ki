module Ki
  class KiApp
    include Middleware::Helpers::HamlCompiler
    include Middleware::Helpers::View

    def call(env)
      path = view_exists?('404') ? view_path('404') : custom_view_path
      html = render_haml_file(path).strip!
      Rack::Response.new(html, 404).finish
    end

    def custom_view_path
      File.join(File.dirname(__FILE__), 'views', '404.haml')
    end
  end
end
