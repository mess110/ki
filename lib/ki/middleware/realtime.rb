# frozen_string_literal: true

module Ki
  module Middleware #:nodoc:
    class Realtime
      include BaseMiddleware

      def call(env)
        req = BaseRequest.new env
        if req.path.to_s == '/realtime/info'
          show_stats
        elsif req.path.to_s == '/realtime' && Faye::WebSocket.websocket?(env)
          handle_websocket env
        else
          @app.call env
        end
      end

      def ws_send(ws, hash)
        ws.send(hash.to_json.to_s)
      end

      def show_stats
        hash = {
          sockets: ::Ki::ChannelManager.sockets
        }
        resp = Rack::Response.new(hash.to_json, 200)
        resp['Content-Type'] = 'application/json'
        resp.finish
      end

      def handle_websocket(env)
        ws = Faye::WebSocket.new(env)

        socket = ::Ki::ChannelManager.connect
        ws_send(ws, socket)

        ws.on :message do |event|
          on_message(ws, socket, event.data)
        end

        timer = EventMachine::PeriodicTimer.new(1) do
          msgs = ::Ki::ChannelManager.tick(socket_id: socket['id'])
          ws_send(ws, { messages: msgs }) if msgs.count.positive?
        end

        ws.on :close do # |event|
          timer.cancel
          ::Ki::ChannelManager.disconnect socket
          ws = nil
        end

        ws.rack_response
      end

      def on_message(ws, socket, data)
        json = JSON.parse(data)
        json['socket_id'] = socket['id']
        if json['type'] == 'subscribe'
          channel_manager_action(json, ws, 'subscribe')
        elsif json['type'] == 'unsubscribe'
          output = ::Ki::ChannelManager.unsubscribe json
          ws_send(ws, output)
        elsif json['type'] == 'publish'
          channel_manager_action(json, ws, 'publish')
        else
          ws_send(ws, { message: 'Please specify a valid type' })
        end
      rescue JSON::ParserError
        ws_send(ws, { message: 'Please send a valid json string' })
      end

      def channel_manager_action(json, ws, action)
        if json['channel_name']
          output = ::Ki::ChannelManager.send(action, json)
          ws_send(ws, output)
        else
          ws_send(ws, { message: 'Please specify a channel_name' })
        end
      end
    end
  end
end
