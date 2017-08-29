require 'spec_helper'

describe Ki::Model::Restrictions do
  before :all do
    class DoubleRestricted < Ki::Model
      requires :foo, :cez
      requires :bar
    end
  end

  it 'merges multiple generic_restrictions' do
    expect(DoubleRestricted.required_attributes).to eq [:foo, :bar, :cez].sort
  end
end
