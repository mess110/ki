require 'spec_helper'

describe Ki do
  it 'should run in test env' do
    Ki::Ki.new.environment.should == 'test'
  end

  it 'should convert string to class corectly' do
    class Cez; end
    class CezBar; end
    'cez'.to_class.should == Cez
    'cez_bar'.to_class.should == CezBar
  end
end
