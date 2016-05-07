require 'singleton'

module Ki
  class KiConfig
    include Singleton

    attr_reader :config, :environment

    def read(environment)
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
      used_middleware = %w(ApiHandler CoffeeCompiler SassCompiler HamlCompiler
                           PublicFileServer)
      used_middleware = @config['middleware'] if @config['middleware']

      used_middleware = add_rm_middleware used_middleware, 'add_middleware', 'push'
      used_middleware = add_rm_middleware used_middleware, 'rm_middleware', 'delete'

      # convert middleware to ruby object
      used_middleware.uniq.map do |middleware|
        Object.const_get('Ki').const_get('Middleware').const_get(middleware)
      end
    end

    def database
      @config['database']
    end

    private

    def add_rm_middleware(used_middleware, key, action)
      if @config.key?(key)
        if @config[key].class != Array
          @config[key] = [@config[key]]
        end
        @config[key].each do |mid|
          used_middleware.send(action, mid)
        end
      end
      used_middleware
    end
  end
end
