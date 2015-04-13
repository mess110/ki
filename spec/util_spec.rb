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

  describe Array do
    it 'responds to present?' do
      expect([]).to_not be_present
      expect([1]).to be_present
    end
  end
end
