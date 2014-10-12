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

    def database
      @config['database']
    end
  end
end
