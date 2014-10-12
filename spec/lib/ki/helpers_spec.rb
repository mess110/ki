require 'spec_helper'

describe Ki::Helpers do
  include Ki::Helpers

  it 'should render_haml' do
    render_haml('%div.foo').should == "<div class='foo'></div>\n"
  end

  it 'should render a partial' do
  end
end
