require 'spec_helper'

describe Ki::Middleware::Helpers::FormatOf do
  let(:obj) {
    @obj = Object.new
    @obj.extend(Ki::Middleware::Helpers::FormatOf)
  }

  it 'should parse url format' do
    [nil, {}, '', '.json'].each do |s|
      obj.format_of(s).should == ''
    end

    ['asd.json', 'asd.json?asd=1'].each do |s|
      obj.format_of(s).should == 'json'
    end
  end
end
