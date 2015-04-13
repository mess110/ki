module Ki
  module Middleware #:nodoc:
    class PublicFileServer
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if public_file_exists? req
          Rack::File.new(Ki::PUBLIC_PATH).call env
        else
          @app.call env
        end
      end
    end
  end
end
