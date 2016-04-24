require 'spec_helper'

# TODO: find a way to test
describe Ki::Middleware::Realtime do
  it 'works' do
    get '/realtime/info'
    expect(last_response.body).to include('404')
  end
end
