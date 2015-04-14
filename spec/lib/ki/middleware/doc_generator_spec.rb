require 'spec_helper'

describe Ki::Middleware::DocGenerator do
  it 'works' do
    get '/instadoc'
    expect(last_response.body).to include('Ki InstaDoc')
  end
end
