# frozen_string_literal: true

require 'spec_helper'

describe Ki::Helpers do
  include Ki::Helpers

  it 'should render_haml' do
    expect(haml('%div.foo')).to eq "<div class='foo'></div>\n"
  end

  it 'renders css tag' do
    expect(css('asd')).to eq "<link href='asd' rel='stylesheet'>\n"
  end

  it 'renders js tag' do
    expect(js('asd')).to eq "<script src='asd'></script>\n"
  end

  it 'renders 404 if partial not found' do
    expect {
      partial('does_not_exist')
    }.to raise_error Ki::PartialNotFoundError
  end

  it 'renders haml' do
    expect(File).to receive(:join).and_return('lib/ki/views/404.haml')
    expect(partial('404')).to include('h1')
  end
end
