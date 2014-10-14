module Ki
  module Middleware #:nodoc:
    module BaseMiddleware
      include FormatOf
      include ViewHelper
      include PublicFileHelper

      def initialize app
        @app = app
      end
    end

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

    class InitMiddleware
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if req.root?
          resp = Rack::Response.new
          resp.redirect('/index')
          resp.finish
        else
          env['CONTENT_TYPE'] = 'application/json' if format_of(req) == 'json'
          @app.call env
        end
      end
    end

    class HamlCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if view_exists?(req)
          render_haml view_path(req)
        else
          @app.call env
        end
      end

      def render_haml file_path
        file_contents = File.read(file_path)

        if view_exists? 'layout'
          layout_contents = File.read(view_path('layout'))
        else
          layout_contents = "= yield"
        end

        html = haml(layout_contents).render do
          haml(file_contents).render
        end

        Rack::Response.new(html).finish
      end

      def haml s
        Haml::Engine.new("- extend Ki::Helpers\n" + s)
      end
    end

    class CoffeeCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        coffee_path = req.path.to_s[0...-3] + '.coffee'
        if !public_file_exists?(req) && format_of(req) == 'js' && public_file_exists?(coffee_path)
          js = CoffeeScript.compile(File.read(public_file_path(coffee_path)))
          Rack::Response.new(js).finish
        else
          @app.call env
        end
      end
    end

    class SassCompiler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        sass_path = req.path.to_s[0...-4] + '.sass'
        # if req ends with css and it does not exist, if a sass file exists instead
        if !public_file_exists?(req) && format_of(req) == 'css' && public_file_exists?(sass_path)
          eng = Sass::Engine.new(File.read(public_file_path(sass_path)), :syntax => :sass)
          Rack::Response.new(eng.render).finish
        else
          @app.call env
        end
      end
    end

    # Handles all API calls
    #
    # Any json request is considered an api call. A request is considered as json
    # if the format is .json or Content-Type header is set to 'application/json'
    #
    # If the query param 'redirect_to' is given, the response will not contain the
    # json output from the url, instead it will redirect to the url given
    class ApiHandler
      include BaseMiddleware

      def call env
        req = BaseRequest.new env
        if req.json?
          begin
            klass = req.to_ki_model_class
            if Model.descendants.include? klass
              # TODO do not have redirect_to param
              model = klass.new(req.to_action, req.params)
              # TODO document this
              if req.params['redirect_to'].nil?
                render model
              else
                # TODO check for injection
                redirect_to req.params['redirect_to']
              end
            else
              raise InvalidUrlError.new("invalid url '#{req.path}'", 404)
            end
          rescue ApiError => e
            render e
          end
        else
          @app.call env
        end
      end

      def redirect_to s
        resp = Rack::Response.new
        resp.redirect(s)
        resp.finish
      end

      def render r
        resp = Rack::Response.new(r.result.to_json, r.status)
        resp['Content-Type'] = 'application/json'
        resp.finish
      end
    end
  end
end
