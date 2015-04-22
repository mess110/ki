require 'spec_helper'

describe Ki::KiConfig do
  let(:config) { Ki::KiConfig.instance }

  it 'should know db name in test env' do
    config.environment.should == 'test'
  end

  it 'is overwritten for testing. see spec_helper' do
    path = config.config_file_path
    path.start_with?('spec/config.yml').should be true
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
end
