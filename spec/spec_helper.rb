$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
ENV['RACK_ENV'] = 'test'

require 'rack/test'
include Rack::Test::Methods

require 'ki'

Ki::KiConfig::CONFIG_FILE_PATH = 'spec/examples/base/config.yml'
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
