module Ki
  module Middleware
    module Helpers
      module RedirectTo
        def redirect_to(path)
          resp = Rack::Response.new
          resp.redirect(path)
          resp.finish
        end
      end
    end
  end
end
