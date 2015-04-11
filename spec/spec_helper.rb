require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
ENV['RACK_ENV'] = 'test'

require 'rack/test'
include Rack::Test::Methods

require 'ki'

config_yml_path = File.exists?('spec/config.yml') ? 'spec/config.yml' : 'spec/config.yml.example'
if config_yml_path.end_with?('example')
  puts 'WARNING: spec/config.yml.example used'
end

Ki::KiConfig::CONFIG_FILE_PATH = config_yml_path
Ki::KiConfig.instance.read 'test'
Ki::Orm::Db.instance.establish_connection

def app
  Ki::Ki.new
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
