require 'spec_helper'

describe Ki::KiConfig do
  it 'should know db name in test env' do
    Ki::KiConfig.instance.environment.should == 'test'
  end

  it 'is overwritten for testing. see spec_helper' do
    path = Ki::KiConfig.instance.config_file_path
    path.start_with?('spec/config.yml').should be true
  end
end
