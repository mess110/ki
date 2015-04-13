require 'singleton'

module Ki
  class KiConfig
    include Singleton

    CONFIG_FILE_PATH = 'config.yml'

    attr_reader :config, :environment

    def read environment
      @environment = environment
      @config = YAML.load_file(CONFIG_FILE_PATH)[environment]
    end

    def middleware
      used_middleware = %w(ApiHandler CoffeeCompiler SassCompiler HamlCompiler PublicFileServer)

      if @config['middleware'].present?
        used_middleware = @config['middleware']
      end

      used_middleware.map { |middleware|
        Object.const_get('Ki').const_get('Middleware').const_get(middleware)
      }
    end

    def database
      @config['database']
    end
  end
end
