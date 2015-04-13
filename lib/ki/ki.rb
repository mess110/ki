module Ki
  class KiApp
    # should never reach this
    # middleware should catch all the requests
    def call env
      s = 'misplaced in space'
      Rack::Response.new(s).finish
    end
  end

  class Ki
    PUBLIC_PATH = 'public'
    VIEWS_PATH = 'views'

    def initialize
      KiConfig.instance.read environment
      Orm::Db.instance.establish_connection

      @app = Rack::Builder.new do
        use Middleware::InitMiddleware
        # TODO what happens with invalid json?
        use Rack::Parser, :content_types => { 'application/json'  => Proc.new { |body| ::MultiJson.decode body } }
        KiConfig.instance.middleware.each do |middleware|
          use middleware
        end
        run KiApp.new
      end
    end

    def environment
      ENV['RACK_ENV']
    end

    def call env
      @app.call env
    end
  end
end
