module Ki
  module Middleware #:nodoc:
    class CoffeeCompiler
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        coffee_path = req.path.to_s[0...-3] + '.coffee'
        if !public_file_exists?(req) && format_of(req) == 'js' && public_file_exists?(coffee_path)
          js = CoffeeScript.compile(File.read(public_file_path(coffee_path)))
          Rack::Response.new(js, 200, { 'Content-Type' => 'application/javascript' }).finish
        else
          @app.call env
        end
      end
    end
  end
end
