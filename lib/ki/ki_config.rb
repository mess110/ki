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
      used_middleware = @config['middleware'] if @config['middleware'].present?

      # TODO: test
      if @config['add_middleware'].present?
        if @config['add_middleware'].class != Array
          @config['add_middleware'] = [@config['add_middleware']]
        end
        @config['add_middleware'].each do |mid|
          used_middleware.push mid
        end
      end

      if @config['rm_middleware'].present?
        if @config['rm_middleware'].class != Array
          @config['rm_middleware'] = [@config['rm_middleware']]
        end
        @config['rm_middleware'].each do |mid|
          used_middleware.delete mid
        end
      end

      # convert middleware to ruby object
      used_middleware.map do |middleware|
        Object.const_get('Ki').const_get('Middleware').const_get(middleware)
      end
    end

    def database
      @config['database']
    end
  end
end
