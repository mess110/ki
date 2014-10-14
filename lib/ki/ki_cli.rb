require 'thor'

module Ki
  module Cli #:nodoc:
    class KiGenerator < Thor::Group #:nodoc:
      include Thor::Actions

      def self.source_root
        File.join(File.dirname(__FILE__), '..', '..')
      end
    end

    class AppGenerator < KiGenerator

      argument :app_name

      def prepare_dir
        unless app_name =~ /^[a-zA-Z0-9-]*$/
          say "App name must contain only alphanumeric characters and -"
          exit 1
        end

        if Dir.exists? app_name
          say "#{app_name} already exists"
          exit 2
        end

        Dir.mkdir app_name
      end

      def create_app
        directory("spec/examples/base", app_name)

        # Set database names
        config_file = File.read("#{app_name}/config.yml")
        config_file.gsub!("name: np_development", "name: #{app_name}_development")
        config_file.gsub!("name: np_test", "name: #{app_name}_test")
        config_file.gsub!("name: np", "name: #{app_name}")
        File.open("#{app_name}/config.yml", "w") {|file| file.puts config_file}

        # Set rvm gemset name
        `echo #{app_name} > #{app_name}/.ruby-gemset`
      end
    end

    class DevServer < KiGenerator
      DEFAULT_PORT = 1337

      argument :port, type: :numeric, desc: "port for ki server.", default: DEFAULT_PORT
      desc "Starts the ki server"

      def start_server
        unless File.exists? 'config.ru'
          say "Working directory should be a ki app."
          exit 3
        end

        `bundle exec rackup -o 0.0.0.0 -p #{port}`
      end
    end

    class Main < Thor
      register AppGenerator, :new, 'new [APP_NAME]', 'generate a new app'
      register DevServer, :server, 'server [PORT]', "start the ki server. Default port is #{DevServer::DEFAULT_PORT}"
    end
  end
end
