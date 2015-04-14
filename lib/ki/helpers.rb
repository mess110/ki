module Ki
  module Helpers
    include Middleware::Helpers::View

    def css url
      render_haml "%link{:href => '#{url}', :rel => 'stylesheet'}"
    end

    def js url
      render_haml "%script{:src => '#{url}'}"
    end

    def render_haml s
      Haml::Engine.new(s).render
    end

    def partial s
      path = view_path(s)
      if File.file?(path)
        render_haml(File.read(path))
      else
        raise PartialNotFoundError.new path
      end
    end
  end
end
