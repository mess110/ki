require 'spec_helper'

describe Ki do
  it 'should run in test env' do
    Ki::Ki.environment.should == 'test'
  end

  it 'should convert string to class corectly' do
    class Cez; end
    class CezBar; end
    expect('cez'.to_class).to eq Cez
    expect('cez_bar'.to_class).to eq CezBar
  end

  describe Array do
    it 'responds to present?' do
      expect([]).to_not be_present
      expect([1]).to be_present
    end
  end
end
