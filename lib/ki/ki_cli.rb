require 'thor'

require 'ki/utils/extra_irb'

module Ki
  module Cli #:nodoc:
    class KiGenerator < Thor::Group #:nodoc:
      include Thor::Actions

      def self.source_root
        File.join(File.dirname(__FILE__), '..', '..')
      end

      def self.requires_ki_directory
        unless File.exist? 'config.ru'
          say 'Working directory should be a ki app.'
          exit 3
        end
      end
    end

    class AppGenerator < KiGenerator
      argument :app_name

      def prepare_dir
        unless app_name =~ /^[a-zA-Z0-9-]*$/
          say 'App name must contain only alphanumeric characters and -'
          exit 1
        end

        if Dir.exist? app_name
          say "#{app_name} already exists"
          exit 2
        end

        Dir.mkdir app_name
      end

      def create_app
        directory('spec/examples/base', app_name)

        # Set database names
        config_file = File.read("#{app_name}/config.yml")
        config_file.gsub!('name: np_development', "name: #{app_name}_development")
        config_file.gsub!('name: np_test', "name: #{app_name}_test")
        config_file.gsub!('name: np', "name: #{app_name}")
        File.open("#{app_name}/config.yml", 'w') { |file| file.puts config_file }

        # Set rvm gemset name
        `echo #{app_name} > #{app_name}/.ruby-gemset`
      end
    end

    class DevServer < KiGenerator
      DEFAULT_PORT = 1337

      argument :port, type: :numeric, desc: 'port for ki server.', default: DEFAULT_PORT
      desc 'Starts the ki server'

      def start_server
        KiGenerator.requires_ki_directory
        `bundle exec rackup -o 0.0.0.0 -p #{port}`
      end
    end

    class DevConsole < KiGenerator
      def start_console
        KiGenerator.requires_ki_directory
        require './app'
        Ki.connect
        IRB.start_session(nil)
      end
    end

    class KiTaskRunner < KiGenerator
      argument :name, type: :string, desc: 'name of the task', default: 'ki_show_task_list_1337'
      desc 'run ki tasks'

      def run_ki_task
        KiGenerator.requires_ki_directory

        if name == 'ki_show_task_list_1337'
          say Dir['tasks/**/*.rb']
        else
          task_path = File.join('tasks', "#{name}.rb")
          unless File.exists?(task_path)
            say "Task #{name} not found in ./tasks/"
            exit 3
          end
          require './app'
          Ki.connect
          say "Running #{name} task."
          say '-' * 80
          require "./#{task_path}"
          say '-' * 80
        end
      end
    end

    class Main < Thor
      register AppGenerator, :new, 'new [APP_NAME]', 'generate a new app'
      register DevServer, :server, 'server [PORT]', "start the ki server. Default port is #{DevServer::DEFAULT_PORT}"
      register DevConsole, :console, 'console', 'start the console'
      register KiTaskRunner, :tasks, 'tasks', 'list tasks'
    end
  end
end
