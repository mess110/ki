module Ki
  class ChannelManager
    def self.connect
      cleanup
      db.insert 'realtime_channel_sockets', {}
    end

    def self.disconnect(socket)
      db.delete 'realtime_channel_sockets', { 'id' => socket['id'] }
      db.delete 'realtime_channel_subscriptions', { 'socket_id' => socket['id'] }
    end

    def self.sockets
      db.find 'realtime_channel_sockets'
    end

    def self.subscribe(json)
      channels = db.find 'realtime_channel_subscriptions', json
      if channels.empty?
        item = db.insert 'realtime_channel_subscriptions', json
        channels.push item
      end
      channels
    end

    def self.unsubscribe(json)
      json.delete('type')
      db.delete 'realtime_channel_subscriptions', json
    end

    def self.publish(json)
      json['created_at'] = Time.now.to_i
      db.insert 'realtime_channel_messages', json
    end

    def self.tick(json)
      subscribed_channels = db.find 'realtime_channel_subscriptions', json
      channel_names = subscribed_channels.map { |sc| sc['channel_name'] }

      t = Time.now.to_i

      messages = db.find 'realtime_channel_messages', {
        'channel_name' => { '$in' => channel_names },
        'created_at' => { '$gt' => t - 1 }
      }
      messages
    end

    def self.cleanup
      db.delete 'realtime_channel_sockets', {}
      db.delete 'realtime_channel_subscriptions', {}
      db.delete 'realtime_channel_messages', {}
    end

    def self.db
      Orm::Db.instance
    end
  end
end
