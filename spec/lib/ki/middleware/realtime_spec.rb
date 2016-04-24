require 'spec_helper'

# TODO: find a way to test
describe Ki::Middleware::Realtime do
  let(:app) { {} }
  let(:realtime) { Ki::Middleware::Realtime.new app }
  let(:req) { Ki::BaseRequest }

  it 'returns /realtime/info' do
    env = Rack::MockRequest.env_for('/realtime/info', { 'REQUEST_METHOD' => 'GET' })
    # get '/realtime/info'
    # expect(last_response.body).to include('404')
    resp = realtime.call env
    expect(resp[0]).to eq 200
    # expect(resp[0]).to eq 302 # redirect
  end

  it 'handle_websocket' do
    env = Rack::MockRequest.env_for('/realtime', { 'REQUEST_METHOD' => 'GET' })

    Ki::Middleware::Realtime.any_instance.stub(:handle_websocket).and_return('handle_websocket')
    Faye::WebSocket.stub(:websocket?).and_return(true)

    resp = realtime.call env
    expect(resp).to eq 'handle_websocket'
  end

  it 'continues call' do
    env = Rack::MockRequest.env_for('/bazinga', { 'REQUEST_METHOD' => 'GET' })
    Hash.any_instance.stub(:call).and_return('continue')
    resp = realtime.call env
    expect(resp).to eq 'continue'
  end
end
