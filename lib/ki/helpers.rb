# frozen_string_literal: true

module Ki
  module Helpers
    include Middleware::Helpers::View

    def css(url)
      haml "%link{:href => '#{url}', :rel => 'stylesheet'}"
    end

    def js(url)
      haml "%script{:src => '#{url}'}"
    end

    def haml(s)
      Haml::Engine.new(s).render
    end

    def partial(s)
      path = view_path(s)
      if File.file?(path)
        haml(File.read(path))
      else
        raise PartialNotFoundError, path
      end
    end
  end
end
