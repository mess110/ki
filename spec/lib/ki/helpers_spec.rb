require 'spec_helper'

describe Ki::Helpers do
  include Ki::Helpers

  it 'should render_haml' do
    render_haml('%div.foo').should == "<div class='foo'></div>\n"
  end

  it 'renders css tag' do
    expect(css('asd')).to eq "<link href='asd' rel='stylesheet'>\n"
  end

  it 'renders js tag' do
    expect(js('asd')).to eq "<script src='asd'></script>\n"
  end
end
