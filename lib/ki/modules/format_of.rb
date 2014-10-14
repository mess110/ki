module Ki
  module Middleware
    module Helpers
      module FormatOf
        def format_of uri
          uri = uri.path if uri.class == BaseRequest
          File.extname(URI.parse(uri).path).gsub('.','')
        rescue URI::InvalidURIError => e
          ''
        end
      end
    end
  end
end
