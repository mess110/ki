# frozen_string_literal: true

module Ki
  module Middleware #:nodoc:
    class SassCompiler
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        sass_path = req.path.to_s[0...-4] + '.sass'
        # if req ends with css and it does not exist, if a sass file exists instead
        if !public_file_exists?(req) && format_of(req) == 'css' && public_file_exists?(sass_path)
          eng = Sass::Engine.new(File.read(public_file_path(sass_path)), syntax: :sass)
          Rack::Response.new(eng.render, 200, { 'Content-Type' => 'text/css' }).finish
        else
          @app.call env
        end
      end
    end
  end
end
