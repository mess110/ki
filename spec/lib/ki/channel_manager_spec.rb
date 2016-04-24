require 'spec_helper'

describe Ki::ChannelManager do
  let(:cm) { Ki::ChannelManager }
  let(:db) { Ki::Orm::Db.instance }

  it 'returns the db connection' do
    expect(cm.db).to eq db
  end

  it 'stores a socket on connection' do
    expect {
      cm.connect
    }.to change { db.count 'realtime_channel_sockets' }.by(1)
  end

  it 'removes a channel socket on disconnect' do
    socket = cm.connect
    expect {
      cm.disconnect(socket)
    }.to change { db.count 'realtime_channel_sockets' }.by(-1)
  end

  it 'removes all the channel subscriptions on disconnect' do
    socket = cm.connect
    cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel')
    cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel-2')
    expect {
      cm.disconnect(socket)
    }.to change { db.count 'realtime_channel_subscriptions' }.by(-2)
  end

  it 'returns the list of channel sockets' do
    cm.cleanup
    expect(cm.sockets).to be_empty

    cm.connect
    expect(cm.sockets).to_not be_empty
  end

  it 'subscribes to a channel' do
    socket = cm.connect

    expect {
      cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel')
    }.to change { db.count 'realtime_channel_subscriptions' }.by(1)
  end

  it 'does not subscribe to the same channel twice' do
    socket = cm.connect

    expect {
      cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel')
      cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel')
    }.to change { db.count 'realtime_channel_subscriptions' }.by(1)
  end

  it 'unsubscribes fom a channel' do
    socket = cm.connect
    cm.subscribe(socket_id: socket['id'], type: 'subscribe', 'channel_name' => 'test-channel')

    expect {
      cm.unsubscribe(socket_id: socket['id'], 'type' => 'unsubscribe', 'channel_name' => 'test-channel')
    }.to change { db.count 'realtime_channel_subscriptions' }.by(-1)
  end

  it 'returns messages from a tick'

  it 'publishes a message' do
    expect {
      item = cm.publish(hello: 'world')
      expect(item['created_at']).to_not be_nil # TODO: might need present?
    }.to change { db.count 'realtime_channel_messages' }.by(1)
  end

  it 'cleans up the data' do
    cm.cleanup
    expect(db.count('realtime_channel_sockets')).to eq 0
    expect(db.count('realtime_channel_subscriptions')).to eq 0
    expect(db.count('realtime_channel_messages')).to eq 0
  end
end
