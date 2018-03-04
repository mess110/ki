# frozen_string_literal: true

module Ki
  class Ki
    PUBLIC_PATH = 'public'
    VIEWS_PATH = 'views'

    def initialize
      Ki.connect

      @app = Rack::Builder.new do
        use Middleware::InitMiddleware

        if Dir.exist?('logs')
          logfile = ::File.join('logs', 'requests.log')
          logger  = ::Logger.new(logfile, 'weekly')
          use Rack::CommonLogger, logger
        end

        use Rack::Parser, content_types: {
          'application/json' => proc { |body| ::MultiJson.decode body }
        }
        if KiConfig.instance.cors?
          use Rack::Cors do
            allow do
              origins '*'
              resource '*', headers: :any, methods: %i[get search put post delete]
              # resource '*', headers: :any, methods: :any # TODO: find out why :any doesn't work
            end
          end
        end
        KiConfig.instance.middleware.each do |middleware|
          use middleware
        end
        run KiApp.new
      end
    end

    def self.connect
      KiConfig.instance.read Ki.environment
      Orm::Db.instance.establish_connection
    end

    def self.environment
      ENV['RACK_ENV'] || 'development'
    end

    def call(env)
      @app.call env
    end
  end
end
