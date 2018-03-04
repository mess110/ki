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
      raise PartialNotFoundError, path unless File.file?(path)
      haml(File.read(path))
    end
  end
end
