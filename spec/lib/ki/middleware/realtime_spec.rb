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

  it 'has ws_send' do
    ws = {}
    ws.stub(:send).and_return true
    expect(realtime.ws_send(ws, {})).to be true
  end

  describe 'on_message' do
    let(:ws) { {} }
    let(:db) { Ki::Orm::Db.instance }

    before :each do
      realtime.stub(:ws_send) do |_arg1, arg2|
        arg2
      end
    end

    it 'requires data to be json parsable' do
      result = realtime.on_message(ws, { 'id' => 'id' }, 'asd')
      expect(result[:message]).to include('valid json string')
    end

    it 'requires a type' do
      result = realtime.on_message(ws, { 'id' => 'id' }, {}.to_s)
      expect(result[:message]).to include('valid type')
    end

    it 'subscribes to a channel' do
      Ki::ChannelManager.cleanup
      expect {
        result = realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'subscribe' }.to_json.to_s)
        expect(result[:message]).to include('channel_name')
      }.to change { db.count 'realtime_channel_subscriptions' }.by(0)

      expect {
        result = realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'subscribe', 'channel_name' => 'channel-1' }.to_json.to_s)
        expect(result[0]['channel_name']).to eq 'channel-1'
      }.to change { db.count 'realtime_channel_subscriptions' }.by(1)
    end

    it 'unsubscribes to a channel' do
      Ki::ChannelManager.cleanup
      result = realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'subscribe', 'channel_name' => 'channel-1' }.to_json.to_s)
      result = realtime.on_message(ws, { 'id' => 'id2' }, { 'type' => 'subscribe', 'channel_name' => 'channel-1' }.to_json.to_s)

      expect {
        result = realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'unsubscribe' }.to_json.to_s)
        expect(result[:deleted_item_count]).to eq 1
      }.to change { db.count 'realtime_channel_subscriptions' }.by(-1)
    end

    it 'publishes on a channel' do
      Ki::ChannelManager.cleanup
      expect {
        realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'publish', 'text' => 'text' }.to_json.to_s)
      }.to change { db.count 'realtime_channel_messages' }.by(0)

      expect {
        realtime.on_message(ws, { 'id' => 'id' }, { 'type' => 'publish', 'channel_name' => 'channel-1', 'text' => 'text' }.to_json.to_s)
      }.to change { db.count 'realtime_channel_messages' }.by(1)
    end
  end
end
