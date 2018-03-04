# frozen_string_literal: true

module Ki
  module Middleware
    module Helpers
      module FormatOf
        def format_of(uri)
          uri = uri.path if uri.class == BaseRequest
          File.extname(URI.parse(uri).path).delete('.')
        rescue URI::InvalidURIError
          ''
        end
      end
    end
  end
end
