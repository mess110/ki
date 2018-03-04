# frozen_string_literal: true

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
      include Helpers::RedirectTo

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

        model = klass.new(req)
        render model
      rescue ApiError => e
        render e
      end

      def render(model)
        if model.is_a?(ApiError) || model.params['redirect_to'].nil?
          resp = Rack::Response.new(model.result.to_json, model.status)
          resp['Content-Type'] = 'application/json'
          resp.finish
        else
          redirect_to model.params['redirect_to']
        end
      end
    end
  end
end
