module Ki
  module Middleware #:nodoc:
    # Handles all API calls
    #
    # Any json request is considered an api call. A request is considered as json
    # if the format is .json or Content-Type header is set to 'application/json'
    #
    # If the query param 'redirect_to' is given, the response will not contain the
    # json output from the url, instead it will redirect to the url given
    class ApiHandler
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        if req.json?
          resourcerize(req)
        else
          @app.call env
        end
      end

      def resourcerize(req)
        klass = req.to_ki_model_class

        unless Model.descendants.include?(klass)
          raise InvalidUrlError.new("invalid url '#{req.path}'", 404)
        end

        model = klass.new(req.to_action, req.params)
        if req.params['redirect_to'].nil? # TODO: document this
          render model
        else
          redirect_to req.params['redirect_to'] # TODO: check for injection
        end
      rescue ApiError => e
        render e
      end

      def redirect_to(s)
        resp = Rack::Response.new
        resp.redirect(s)
        resp.finish
      end

      def render(r)
        resp = Rack::Response.new(r.result.to_json, r.status)
        resp['Content-Type'] = 'application/json'
        resp.finish
      end
    end
  end
end
