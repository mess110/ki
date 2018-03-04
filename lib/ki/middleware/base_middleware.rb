# frozen_string_literal: true

module Ki
  module Middleware #:nodoc:
    module BaseMiddleware
      include Helpers::FormatOf
      include Helpers::View
      include Helpers::PublicFile

      def initialize(app)
        @app = app
      end
    end
  end
end
