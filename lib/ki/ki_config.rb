require 'singleton'

module Ki
  class KiConfig
    include Singleton

    attr_reader :config, :environment

    def read environment
      @environment = environment
      @config = YAML.load_file(config_file_path)[environment]
      @config['cors'] ||= true
    end

    def config_file_path
      'config.yml'
    end

    def cors?
      @config['cors']
    end

    def middleware
      used_middleware = %w(ApiHandler CoffeeCompiler SassCompiler HamlCompiler PublicFileServer)

      if @config['middleware'].present?
        used_middleware = @config['middleware']
      end

      # convert middleware to ruby object
      used_middleware.map { |middleware|
        Object.const_get('Ki').const_get('Middleware').const_get(middleware)
      }
    end

    def database
      @config['database']
    end
  end
end
