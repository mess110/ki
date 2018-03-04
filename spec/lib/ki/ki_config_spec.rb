require 'spec_helper'

describe Ki::KiConfig do
  let(:config) { Ki::KiConfig.instance }

  it 'should know db name in test env' do
    expect(config.environment).to eq 'test'
  end

  it 'is overwritten for testing. see spec_helper' do
    path = config.config_file_path
    expect(path).to be_start_with('spec/config.yml')
  end

  it 'defaults cors to true' do
    expect(config).to be_cors
  end

  it 'has a database method' do
    expect(config.database['name']).to eq 'np_test'
  end

  it 'has a middleware method' do
    expect(config.middleware).to_not be_empty
  end

  it 'rm_middleware' do
    config.config['rm_middleware'] = 'AdminInterfaceGenerator'
    expect(config.middleware).to_not include(Ki::Middleware::AdminInterfaceGenerator)
  end

  it 'add_middleware' do
    config.config['rm_middleware'] = 'Realtime'
    config.middleware
    expect(config.middleware).to_not include(Ki::Middleware::Realtime)
    config.config['rm_middleware'] = []
    config.config['add_middleware'] = 'Realtime'
    expect(config.middleware).to include(Ki::Middleware::Realtime)
  end

  it 'add_middleware/rm_middleware accepts an array' do
    config.config['rm_middleware'] = 'Realtime'
    expect(config.middleware).to_not include(Ki::Middleware::Realtime)
    config.config['rm_middleware'] = []

    config.config['add_middleware'] = ['Realtime']
    expect(config.middleware).to include(Ki::Middleware::Realtime)
  end

  it 'does not add duplicate middleware' do
    config.config['add_middleware'] = %w(Realtime Realtime)
    expect(config.middleware.to_s.scan(/Realtime/).count).to eq 1
  end
end
