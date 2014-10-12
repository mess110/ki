require 'spec_helper'

describe Ki::KiConfig do
  it 'should know db name in test env' do
    Ki::KiConfig.instance.environment.should == 'test'
  end
end
